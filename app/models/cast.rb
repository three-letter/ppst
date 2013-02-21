#coding: utf-8

class Cast < ActiveRecord::Base
  attr_accessible :free_time, :price, :title, :user_id, :url

  validates :title, :presence => { :message => "标题不能为空" },
                    :length => { :maximum => 32, :message => "标题最长为32字符" }
  validates :free_time, :numericality =>{ :only_integer => true, :message => "试看时间必须是整数" }

  belongs_to :user
  has_many :comments

  scope :recent_casts, lambda { |uid, limit| joins(:user).order("created_at desc").where("users.id = ?", uid).limit(limit) }

  def video_url
    "http://ppst.qiniudn.com/#{url}"
  end

end
