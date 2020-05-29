class UsersController < ApplicationController
  before_action :get_user, only: [:show, :edit, :update, :destroy]
  before_action :require_user, only: [:edit, :update, :destroy]
  before_action :require_same_user, only: [:edit, :update, :destroy]

  def show
    @user_posts = @user.posts.reverse_order.page(params[:page]).
      per(5)
  end

  def new
    redirect_to user_path(session[:user_id]) if logged_in?
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    # Try to save new user & display success message, else show error
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Signed up successfully. Welcome #{@user.username}!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    # Try to update user & display proper feedback message
    if @user.update(user_params)
      flash[:notice] = "User was updated successfully."
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    session[:user_id] = nil
    flash[:notice] = "Successfully deleted account."
    redirect_to posts_path
  end

  private

  def get_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end
  
  def require_same_user
    if current_user != @user
      flash[:alert] = "You do not have permission to do that."
      redirect_back fallback_location: @user
    end
  end
end