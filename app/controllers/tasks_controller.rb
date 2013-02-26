#coding: utf-8

class TasksController < ApplicationController
  before_filter :authentication

  def index
    @todos = Task.with_status(0)
    @dones = Task.with_status(1)
    @task = Task.new()
  end

  def create
    @task = Task.new(params[:task].merge(user_id: @current_user.id).merge(status: 0))
    respond_to do |format|
      if @task.save
        flash[:notice_task] = "添加待办任务成功" 
      else
        flash[:notice_task] = @task.errors[:info].blank? ? "添加待办任务失败" : @task.errors[:info][0].to_s
      end
      format.js
    end
  end

  def done
    task = Task.find_by_id(params[:id])
    task.status = 1
    task.save
    redirect_to action: "index"
  end

  def destroy
    task = Task.find_by_id(params[:id])
    task.destroy
    redirect_to action: "index"
  end
end
