#coding: utf-8
require 'json'
require 'net/http'
require File.expand_path("../../../lib/crypt-xxtea/xxtea", __FILE__)

class CastsController < ApplicationController
  before_filter :authentication

  def index
    @casts = Cast.order("updated_at desc").all
  end

  def new
    @cast = Cast.new
  end

  def create
    @cast = Cast.new(params[:cast].merge(user_id: current_user.id))
    
    Qiniu::RS.upload_file :uptoken    => get_upload_token,
                          :file       => params[:cast][:video].tempfile.path,
                          :bucket     => "ppst",
                          :key        => "#{current_user.id}-#{params[:cast][:video].original_filename}",
                          :callback_params => {bucket: "<BucketName>", key: "<FileUniqKey>", uid: "<customer>"}
    #if @cast.save
    #  flash[:cast] = "视频上传成功"
    #  redirect_to @cast
    #else
    #  render :new
    #end
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
                                    :callback_url         =>  "http://localhost:3000",
                                    :callback_body_type   =>  "application/json",
                                    :customer             =>  current_user.id.to_s,
                                    :escape               =>  1,
                                    :async_options        =>  "avthumb/mp4"
  end

end
