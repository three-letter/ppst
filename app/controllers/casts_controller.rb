#coding: utf-8
require 'json'
require 'base64'
require 'net/http'
require 'juggernaut'
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
    Juggernaut.publish("/msg-#{@current_user.id}", "#{@current_user.id}");
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

end
