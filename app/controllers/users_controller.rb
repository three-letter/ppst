#coding: utf-8
require 'json'
require File.expand_path("../../../lib/crypt-xxtea/xxtea",__FILE__)

class UsersController < ApplicationController

  before_filter :authentication, :except => [:new, :create]

  def index
    render :index
  end

  def home
    user_id = @current_user.id if params[:id].blank?
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
    key = "avatar_#{@current_user.id}_#{Time.now.to_i}.jpg"
    @upload_auth   = get_upload_token
    @upload_action = gen_action key
    @upload_key = XXTEA.encrypt(XXTEA::SKEY,key)
  end

  def avatar_save
    respond_to do |format|
      if cropping?
        url = XXTEA.decrypt(XXTEA::SKEY,params[:url])
        rst = avatar_save_qiniu url
        if rst
          user = User.find_by_id(params[:id])
          user.url = url
          flash[:avatar_notice] = "头像更新成功"
          flash[:avatar_notice] = "头像更新失败" unless user.save
          format.html { redirect_to user_path user }
        end
      else
        format.html { redirect_to root_path }
      end  
    end
  end

  private
    def cropping?
     !params[:crop_x].blank? && !params[:crop_y].blank? && !params[:crop_w].blank? && !params[:crop_h].blank? && !params[:url].blank? && !params[:id].blank?
    end
    # 根据前端获取的裁剪参数x y w h　裁剪并保存大图
    # 根据保存的大图进行小图　微图的缩放和保存
    def avatar_save_qiniu key
      index = key.sub('.jpg', '')
      mini_avatar = "#{index}_mini.jpg"
      small_avatar = "#{index}_small.jpg"
      large_avatar = "#{index}_large.jpg"
      Qiniu::RS.image_mogrify_save_as("ppst", large_avatar, Qiniu::RS.get('ppst',key)["url"], {:crop => "!#{params[:crop_w]}x#{params[:crop_h]}a#{params[:crop_x]}a#{params[:crop_y]}", "save-as".to_sym => UrlSafeBase64Encode("ppst:#{large_avatar}") })
      
      Qiniu::RS.image_mogrify_save_as("ppst", mini_avatar, Qiniu::RS.get('ppst',large_avatar)["url"], {:thumbnail => "!#{User::AVATAR_MW}x#{User::AVATAR_MH}", "save-as".to_sym => UrlSafeBase64Encode("ppst:#{mini_avatar}") })
      Qiniu::RS.image_mogrify_save_as("ppst", small_avatar, Qiniu::RS.get('ppst',large_avatar)["url"], {:thumbnail => "!#{User::AVATAR_SW}x#{User::AVATAR_SH}", "save-as".to_sym => UrlSafeBase64Encode("ppst:#{small_avatar}") })
    end

end
