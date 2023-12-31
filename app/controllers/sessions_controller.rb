class SessionsController < ApplicationController

  before_action :logged_in_redirect, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by_username(session_params[:username])
    if user && user.authenticate(session_params[:password])
      session[:user_id] = user.id
      flash[:success] = "Logged in successfully"
      redirect_to root_path
    else
      flash.now[:error] = "There was something wrong with your login details"
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "Logged out"
    redirect_to login_path
  end

  private

  def session_params
    params.require(:session).permit(:username, :password)
  end

  def logged_in_redirect
    if logged_in?
      flash[:error] = "You are already logged in"
      redirect_to root_path      
    end
  end

end