#coding: utf-8
require File.expand_path("../../../lib/crypt-xxtea/xxtea",__FILE__)

class UsersController < ApplicationController

  before_filter :authentication, :except => [:new, :create]

  def index
    render :index
  end

  def home
    user_id = current_user.id if params[:id].blank?
    @user = User.find_by_id(user_id)
    @casts = Cast.recent_casts(user_id, 5)
    @comments = Comment.recent_comments(user_id, 5)
  end

  def new
    if current_user
      flash[:notice] = "您已经登陆"
      redirect_to root_path
    else
      @user = User.new
      render :new
    end
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      signin(@user)
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @user = User.find_by_id(params[:id])
  end

  def edit
    @user = User.find_by_id(params[:id])
  end

  def update
    @user = User.find_by_id(params[:id])
    if @user.update_attributes(params[:user])
      @user.reprocess_avatar if @user.cropping?
      if params[:user][:avatar].blank?
        redirect_to root_path
      else
        render "crop" 
      end
    else
      render "edit" 
    end
  end 

  def avatar
    @user = @current_user
    key = gen_key
    @upload_auth   = get_upload_token
    @upload_action = gen_action key
    @upload_key = XXTEA.encrypt(XXTEA::SKEY,key)
  end

end
