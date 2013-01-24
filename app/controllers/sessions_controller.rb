#coding: utf-8

class SessionsController < ApplicationController
  
  before_filter :authentication, :only => [:destroy]
  
  def new
    if current_user
      flash[:notice] = "您已经登陆"
      redirect_to root_path
    else
      render :new
    end
  end
  
  def create
    user = User.authenticate(params[:name], params[:pwd])
    if user
      signin(user)
      if session[:last_url] 
        redirect_to session[:last_url]
      else
        redirect_to users_path
      end
    else
      flash[:login] = "用户名或密码错误"
      render :new
    end
  end

  def destroy
    user = current_user
    if user
      logout(user)
      flash[:notice] = "您已经退出"
      redirect_to root_path
    else
      flash[:notice] = "您还未登陆"
      redirect_to login_path
    end
  end

end
