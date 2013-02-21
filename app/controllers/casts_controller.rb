#coding: utf-8
require 'json'
require 'base64'
require 'net/http'
require 'digest/sha2'

class CastsController < ApplicationController
  before_filter :authentication, :except => :set_url

  def index
    @casts = Cast.order("updated_at desc").all
  end

  def new
    @cast = Cast.new
  end

  def create
    @cast = Cast.new(params[:cast].merge(user_id: current_user.id))
    respond_to do |format|
      if @cast.save
        key = gen_key
        @upload_auth   = get_upload_token
        @upload_action = gen_action key
        @upload_params = "id=10&key=#{key}"
        #@upload_params = "id=#{@cast.id}&key=#{key}"
        format.html {render action: "up_qiniu" }
      else
        format.html { render action: "new"}
      end
    end
  end

  def edit
  end

  def show
    @cast = Cast.find_by_id(params[:id])
  end

  def set_url
    if !params[:key].blank? && !params[:id].blank?
      cast = Cast.find_by_id(params[:id])
      cast.url = params[:key].strip
      cast.save
      respond_to do |format|
        format.text "id=#{cast.id}&key=#{params[:key]}"
      end
    end
  end

  def upload
    @result = Qiniu::RS.upload_file :uptoken    => get_upload_token,
                                    :file       => params[:file].tempfile.path,
                                    :bucket     => "ppst",
                                    :key        => gen_upload_key
    respond_to do |format|
      unless @result.blank?
        format.json { render json: video_to_json(params[:file]) }
      end
    end
  end

  private

  def get_upload_token
    Qiniu::RS.generate_upload_token :scope                =>  "ppst",
                                    :expires_in           =>  60 * 30,
                                    :callback_url         =>  "http://ppst.herokuapp.com/casts/set_url",
                                    :callback_body_type   =>  "application/x-www-form-urlencoded",
                                    :customer             =>  current_user.id.to_s,
                                    :escape               =>  1,
                                    :async_options        =>  "avthumb/mp4"
  end

  def video_to_json file
    js ={ 
      "key"  => gen_upload_key,
      "name" => file.original_filename,
      "size" => file.size 
    }
    js = JSON js
  end

  def gen_action key
    entry_uri = "ppst:#{key}"
    entry_uri_64 = Base64.encode64(entry_uri)
    entry = entry_uri_64.strip.gsub("+","-").gsub("/", "_")
    "/rs-put/#{entry}"
  end

  def gen_key
    str = "#{current_user.id}-#{Time.now.to_i}"
    Digest::SHA2.hexdigest(str)
  end

  def gen_upload_key 
    str = "#{current_user.id}-#{params[:file].original_filename}"
    Digest::SHA2.hexdigest(str)
  end

end
