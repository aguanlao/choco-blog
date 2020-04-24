class UsersController < ApplicationController
  before_action :get_user, only: [:show, :edit, :update]

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    # Try to save new user & display success message, else show error
    if @user.save
      flash[:notice] = "Signed up successfully. Welcome #{@user.username}!"
      # TODO: Change redirect on success
      redirect_to posts_path
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
      # TODO: Change redirect on success
      redirect_to posts_path
    else
      render 'edit'
    end
  end  

  private

  def get_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

end