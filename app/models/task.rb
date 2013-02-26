#coding: utf-8

class Task < ActiveRecord::Base
  attr_accessible :info, :status, :user_id

  validates :info, :presence => { :message => "待办任务信息不能为空"}
  
  belongs_to :user

  scope :with_status, lambda {|st| joins(:user).where("status = ?", st) }

  def done?
    status == 1
  end

end
