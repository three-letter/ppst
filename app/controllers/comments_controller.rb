#coding: utf-8

class CommentsController < ApplicationController
  before_filter :fetch_cast, :authentication


  def index
    @comments = Comment.order("created_at desc").all
  end

  def create
    @comment = @cast.comments.build(params[:comment].merge(user_id: current_user.id))
    flash[:notice_comment] = "评论成功" if @comment.save
    scan_user(@comment.content)
    respond_to do |format|
      format.js
    end
  end

  private 
    def fetch_cast
      if params[:cast_id].blank?
        flash[:notice] = "该视播不存在"
        redirect_to root_path
      else
        @cast = Cast.find_by_id(params[:cast_id])
      end
    end

    def scan_user textarea
      names = textarea.scan(/@([^@]+?)\s+/).flatten
      return [] if names.size == 0
      names.delete(@current_user.name)
      @at_users = User.where(:name => names)
    end

end
