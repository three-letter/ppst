#coding: utf-8
require 'json'
require 'base64'
require 'net/http'
require 'digest/sha2'
require File.expand_path("../../../lib/crypt-xxtea/xxtea",__FILE__)


class CastsController < ApplicationController
  before_filter :authentication, :except => :set_url

  def index
    @casts = Cast.order("updated_at desc").all
  end

  def new
    @cast = Cast.new
    key = gen_key
    @upload_auth   = get_upload_token
    @upload_action = gen_action key
    @upload_key = XXTEA.encrypt(XXTEA::SKEY,key)
  end

  def create
    @cast = Cast.new(params[:cast].merge(user_id: current_user.id))
    @cast.url = XXTEA.decrypt(XXTEA::SKEY,@cast.url)
    respond_to do |format|
      if @cast.save
        format.html {redirect_to action: "show", id: @cast.id }
      else
        @cast.url = XXTEA.encrypt(XXTEA::SKEY,@cast.url)
        format.html { render action: "new"}
      end
    end
  end

  def edit
  end

  def show
    @cast = Cast.find_by_id(params[:id])
  end

  private

  def get_upload_token
    Qiniu::RS.generate_upload_token :scope                =>  "ppst",
                                    :expires_in           =>  60 * 30,
#                                    :callback_url         =>  "http://ppst.herokuapp.com/casts/set_url",
                                    :callback_body_type   =>  "application/x-www-form-urlencoded",
                                    :customer             =>  current_user.id.to_s,
                                    :escape               =>  1,
                                    :async_options        =>  "avthumb/mp4"
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

end
