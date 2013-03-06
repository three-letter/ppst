require 'net/http'

module SessionsHelper

  def signin user
    cookies.permanent.signed[:token] = [user.id, user.salt]
  end
  
  def current_user
    @current_user ||= user_from_token
  end
  
  def sign_in?
    !current_user.nil?
  end
  
  def logout user
    @current_user = nil
    cookies.permanent.signed[:token] = [nil, nil]
  end

  def authentication
    unless sign_in?
      session[:last_url] = request.url
      redirect_to login_path
    end
  end

  def UrlSafeBase64Encode str
    entry_uri_64 = Base64.encode64(str)
    entry_uri_64.strip.gsub("+","-").gsub("/", "_")
  end

  def get_download_token
    Qiniu::RS.generate_download_token :expires_in => 3600,
                                      :pattern    => "*/*" 
  end

  def get_upload_token
    Qiniu::RS.generate_upload_token :scope                =>  "ppst",
                                    :expires_in           =>  60 * 30,
#                                    :callback_url         =>  "http://ppst.herokuapp.com/casts/set_url",
                                    :callback_body_type   =>  "application/x-www-form-urlencoded",
                                    :customer             =>  current_user.id.to_s,
                                    :escape               =>  1
  end

  def broadcast(channel, &block)
    msg = { :channel => channel, :data => capture(&block), :ext => {:auth_token => FAYE_TOKEN}}
    uri = URI.parse("http://pfaye.herokuapp.com/faye")
    Net::HTTP.post_form(uri, :message => msg.to_json)
  end

  def gen_action key
    entry_uri = "ppst:#{key}"
    entry = UrlSafeBase64Encode(entry_uri) 
    "/rs-put/#{entry}"
  end

  def gen_key
    str = "#{current_user.id}-#{Time.now.to_i}"
    Digest::SHA2.hexdigest(str)
  end

  private
    def user_from_token
      User.authenticate_by_token(*token)
    end
    def token
      cookies.signed[:token] || [nil, nil]
    end

end
