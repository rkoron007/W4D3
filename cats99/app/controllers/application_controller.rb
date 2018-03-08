class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception
  helper_method :current_user, :login!, :logout, :login?

  def current_user
    @current_user ||=  User.find_by(session_token: session[:session_token])
  end

  def login!
    token = current_user.reset_session_token!
    session[:session_token] = token
  end

  def login?
    !!current_user
  end

  def logout
    current_user.reset_session_token!
    session[:session_token] = nil
  end


end
