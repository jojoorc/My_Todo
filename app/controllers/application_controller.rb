class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :logined?

  def login_as(user)
    session[:user_id] = user.id
    @current_user ||= user
  end

  def logined?
    current_user != nil
  end

  def current_user
    if(session[:user_id])
      @current_user = User.find(session[:user_id])
    end
  end

end
