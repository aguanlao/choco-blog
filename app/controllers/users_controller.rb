class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    # Try to save new user & display success message, else show error
    if @user.save
      flash[:notice] = "Signed up successfully. Welcome #{@user.username}!"
      redirect_to posts_path
    else
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

end