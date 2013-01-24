#coding: utf-8

class Cast < ActiveRecord::Base
  attr_accessible :free_time, :price, :title, :user_id, :video

  validates :title, :presence => { :message => "标题不能为空" },
                    :length => { :maximum => 32, :message => "标题最长为32字符" }
  validates :free_time, :numericality =>{ :only_integer => true, :message => "试看时间必须是整数" }

  has_attached_file :video, :url => "/assets/videos/:id/:style/:basename.:extension" ,
                            :path => ":rails_root/public/assets/videos/:id/:style/:basename.:extension"
  validates_attachment :video, :presence => { :message => "上传视频不能为空" },
                               :content_type => { :content_type => ["video/mp4"], :message => "目前视频上传只支持MP4格式" },
                               :size => { :in => 1..100.megabytes, :message => "上传视频支持最大100M" }

  belongs_to :user
  has_many :comments

   scope :recent_casts, lambda { |uid, limit| joins(:user).order("created_at desc").where("users.id = ?", uid).limit(limit) }
end
