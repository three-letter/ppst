require File.expand_path("../../../lib/crypt-xxtea/xxtea",__FILE__)

module UsersHelper
 
  def get_avatar key_crypt
    key = XXTEA.decrypt(XXTEA::SKEY, key_crypt)
    "http://ppstd.dn.qbox.me/#{key}"
  end

  def get_crop_avatar key_crypt
    avatar = get_avatar key_crypt
    #"#{avatar}?imageView/2/w/#{User::AVATAR_XLW}/h/#{User::AVATAR_XLH}"
    "#{avatar}?imageView/2/w/#{User::AVATAR_XLW}/"
  end

end
