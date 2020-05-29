class SessionsController < ApplicationController

  def new
    redirect_to user_path(session[:user_id]) if logged_in?
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:notice] = "Logged in successfully."
      redirect_to user
    else
      flash.now[:error] = "Incorrect username and/or password."
      render 'new'      
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "Logged out successfully."
    redirect_to root_path
  end

end