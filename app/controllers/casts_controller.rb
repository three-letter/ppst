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
    if @cast.save
      flash[:cast] = "视频上传成功"
      redirect_to @cast
    else
      render :new
    end
  end

  def edit
  end

  def show
    @cast = Cast.find_by_id(params[:id])
  end

  def upload
    time, crypt = XXTEA.encrypt_ku6
    url  = URI.parse(XXTEA::URL) unless XXTEA::URL.is_a?(URI) 
    conn = Net::HTTP.new(url.host, url.port)
    data = "method=#{params[:method]}&sn=#{XXTEA::SN}&posttime=#{time}&token=#{crypt}&title=#{params[:vtitle]}&cid=#{params[:cid]}&vid=#{params[:vid]}"
    rsp  = conn.post("/v3/api",data,{})
    json = JSON rsp.body
    @vid = json["vid"]
  end
end
