#coding: utf-8

class Comment < ActiveRecord::Base
  attr_accessible :cast_id, :content, :user_id

  validates :content, :presence => { :message => "评论不能为空" },
                      :length => { :maximum => 128, :message => "评论最长为128个字符" }

  belongs_to :user
  belongs_to :cast

   scope :recent_comments, lambda { |uid, limit| joins(:user).order("created_at desc").where("users.id = ?", uid).limit(limit) }
end
