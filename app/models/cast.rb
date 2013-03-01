#coding: utf-8

class Cast < ActiveRecord::Base
  attr_accessible :free_time, :price, :title, :user_id, :url, :tag
  attr_accessor :tag

  validates :title, :presence => { :message => "标题不能为空" },
                    :length => { :maximum => 32, :message => "标题最长为32字符" }
  validates :free_time, :numericality =>{ :only_integer => true, :message => "试看时间必须是整数" }
  validates :url, :presence => { :message => "视频信息不能为空" }

  belongs_to :user
  has_many :comments
  has_and_belongs_to_many :tags

  scope :recent_casts, lambda { |uid, limit| joins(:user).order("created_at desc").where("users.id = ?", uid).limit(limit) }

  def video_url
    "http://ppstd.dn.qbox.me/#{url}"
  end

  def image_url
    "http://ppstd.dn.qbox.me/#{url}/?vframe/jpg/offset/10/w/160/h/100"
  end

  def tag_names
    names = []
    tags.each do |tag|
      names << tag.name
    end
    names << "暂无" if names.size == 0
    names.join(" ")
  end

end
