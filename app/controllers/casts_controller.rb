#coding: utf-8

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
end
