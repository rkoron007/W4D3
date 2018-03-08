class SessionsController < ApplicationController

  def new
    render :new
  end

  def create
    user = User.find_by_credentials(params[:user][:user_name], params[:user][:password])
    if user
      @current_user = user
      login!
      redirect_to cats_url
    else
      flash[:errors] << 'not a valid user'
      redirect_to new_session_url
    end
  end

  def destroy
    if login?
      logout
      redirect_to cats_url
    else
      flash[:errors] << 'not logged in!'
      redirect_to new_session_url
    end
  end

end
