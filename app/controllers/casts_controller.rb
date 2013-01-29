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
  end

  def edit
  end

  def show
    @cast = Cast.find_by_id(params[:id])
  end


  def upload
    if params[:upload].blank?
      flash[:notice_upload] = "请选择上传文件"
    else
      #begin
        #result = Qiniu::RS.upload_file :uptoken    => get_upload_token,
        #                               :file       => params[:upload].tempfile.path,
        #                               :bucket     => "ppst",
        #                               :key        => "#{current_user.id}-#{params[:upload].original_filename}"
        #flash[:notice_upload] = "上传成功"
      #rescue
      flash[:notice_upload] = "上传失败"
        #flash[:notice_upload] = "上传失败"
      #end
    end
    respond_to do |format|
      format.js
    end
  end

  private

  def get_upload_token
    Qiniu::RS.generate_upload_token :scope                =>  "ppst",
                                    :expires_in           =>  60 * 30,
                                    :callback_url         =>  "",
                                    :callback_body_type   =>  "application/json",
                                    :customer             =>  current_user.id.to_s,
                                    :escape               =>  1,
                                    :async_options        =>  "avthumb/mp4"
  end

end
