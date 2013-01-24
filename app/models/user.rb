#coding: utf-8
require 'digest/sha2'

class User < ActiveRecord::Base
  attr_accessible :alipay, :email, :name, :password, :salt, :pwd, :pwd_confirmation, :crop_x, :crop_y, :crop_w, :crop_h, :avatar
  attr_accessor :pwd

  # all validates for the field of user
  validates :name, :presence => { :message => "用户名不能为空" },
                   :uniqueness => { :message => "用户名已经存在" },
                   :length => { :within => 2..8, :message => "用户名长度为2到8" }
  validates :pwd,  :presence => { :on => :create, :message => "密码不能为空" },
                   :confirmation => { :message => "两次密码不一致" }

   # the avatar config
   AVATAR_SW = 56
   AVATAR_SH = 56
   AVATAR_LW = 120
   AVATAR_LH = 120
   has_attached_file :avatar, :styles => { :mini => "20x20#", :small => "#{AVATAR_SW}x#{AVATAR_SH}#", :large => "#{AVATAR_LW}x#{AVATAR_LH}>" },
                              :processors => [ :cropper ],
                              :url => "/assets/avatars/:id/:style/:basename.:extension",
                              :path => ":rails_root/public/assets/avatars/:id/:style/:basename.:extension"
   validates_attachment :avatar, :content_type => { :content_type => ["image/jpeg", "image/jpg", "image/png"], :message => "目前只支持JPEG JPG PNG格式" },
                                 :size => { :in => 1..1024.kilobytes, :message => "上传图片最大1M" }
   attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
   # after_update :reprocess_avatar, :if => :cropping? #使用这个过滤器会导致无限循环，暂时没解决方法，将该操作至于contrller中

   has_many :casts
   has_many :comments




   def cropping?
     !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
   end
    
   def reprocess_avatar
      avatar.reprocess!
    end
  
   def avatar_geometry(style = :original)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file(avatar.path(style))
   end

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
    unless avatar.blank?
      avatar.url(type)
    else
      "/assets/avatar_#{type.to_s}.jpg"
    end
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
