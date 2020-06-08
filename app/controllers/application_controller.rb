class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?
  
  def current_user
    begin  
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    rescue ActiveRecord::RecordNotFound
      session[:user_id] = nil
    end
  end

  def logged_in?
    !!current_user
  end

  def require_user
    unless logged_in?
      flash[:alert] = "You must be logged in to do that."
      redirect_to login_path
    end
  end

  def require_admin
    unless logged_in? && current_user.is_admin?
      flash[:alert] = "You must be an administrator to do that."
      redirect_to posts_path
    end
  end
end
