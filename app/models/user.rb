#coding: utf-8
require 'digest/sha2'

class User < ActiveRecord::Base
  attr_accessible :alipay, :email, :name, :password, :salt, :pwd, :pwd_confirmation, :crop_x, :crop_y, :crop_w, :crop_h, :url
  attr_accessor :pwd

  # all validates for the field of user
  validates :name, :presence => { :message => "用户名不能为空" },
                   :uniqueness => { :message => "用户名已经存在" },
                   :length => { :within => 2..8, :message => "用户名长度为2到8" }
  validates :pwd,  :presence => { :on => :create, :message => "密码不能为空" },
                   :confirmation => { :message => "两次密码不一致" }

   # the avatar config
   AVATAR_MW = 20
   AVATAR_MH = 20
   AVATAR_SW = 56
   AVATAR_SH = 56
   AVATAR_LW = 120
   AVATAR_LH = 120
   AVATAR_XLW = 350
   AVATAR_XLH = 350
   attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

   has_many :casts
   has_many :comments


  before_save :encrypt_password

  def self.authenticate(username,psd)
    user = User.find_by_name(username)
    if user
      user = nil unless user.has_password?(psd)
    end
    user
  end

  def self.authenticate_by_token(id, salt)
    user = User.find_by_id(id)
    (user && user.salt == salt) ? user : nil
  end

  def has_password?(psd)
    password == encrypt(psd)
  end

  def avatar_type type
    default_url = "avatar_1_1361677063.jpg" 
    img_url = url.blank? ? default_url : url
    index = img_url.sub('.jpg', '')
    "http://ppstd.dn.qbox.me/#{index}_#{type.to_s}.jpg"
  end


  private
    def encrypt_password
      unless pwd.blank?
        self.salt = "#{Time.now.to_i + rand(10000)}" if new_record?
        self.password = encrypt(pwd)
      end
    end

    def encrypt(str)
      Digest::SHA2.hexdigest("#{salt}_#{str}")
    end
    

end
