#coding: utf-8
require 'json'
require 'base64'
require 'net/http'
require 'digest/sha2'
require File.expand_path("../../../lib/crypt-xxtea/xxtea", __FILE__)

class CastsController < ApplicationController
  before_filter :authentication

  def index
    @casts = Cast.order("updated_at desc").all
  end

  def new
    @cast = Cast.new
    @upload_auth   = get_upload_token
    @upload_action = gen_action
  end

  def create
    @cast = Cast.new(params[:cast].merge(user_id: current_user.id))
    respond_to do |format|
      if @cast.save
        format.html { redirect_to action: "show", :id => @cast}
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

  def up_qiniu
  end


  def upload
    @result = Qiniu::RS.upload_file :uptoken    => get_upload_token,
                                    :file       => params[:upload].tempfile.path,
                                    :bucket     => "ppst",
                                    :key        => gen_upload_key
    respond_to do |format|
      unless @result.blank?
        format.json { render json: video_to_json(params[:upload]) }
      end
    end
  end

  private

  def get_upload_token
    Qiniu::RS.generate_upload_token :scope                =>  "ppst",
                                    :expires_in           =>  60 * 30,
#                                    :callback_url         =>  "",
                                    :callback_body_type   =>  "application/json",
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

  def gen_action
    entry_uri = "ppst:#{gen_key}"
    entry_uri_64 = Base64.encode64(entry_uri)
    entry = entry_uri_64.gsub("+","-").gsub("/", "_")
    "/rs-put/#{entry}"
  end

  def gen_key
    str = "#{current_user.id}-#{Time.now.to_i}"
    Digest::SHA2.hexdigest(str)
  end

  def gen_upload_key 
    str = "#{current_user.id}-#{params[:upload].original_filename}"
    Digest::SHA2.hexdigest(str)
  end

end
