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

  private
    def user_from_token
      User.authenticate_by_token(*token)
    end
    def token
      cookies.signed[:token] || [nil, nil]
    end

end
