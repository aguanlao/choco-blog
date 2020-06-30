class UsersController < ApplicationController
  before_action :get_user, only: [:show, :edit, :update, :destroy]
  before_action :require_user, only: [:edit, :update, :destroy]
  before_action :require_same_user, only: [:edit, :update, :destroy]

  def show
    @user_posts = @user.posts.reverse_order.page(params[:page]).
      per(5)
    # TODO: Possibly refactor into one query
    category_ids = Post.where(user: @user).joins(:post_categories).distinct.
      pluck(:"post_categories.category_id")
    @user_tags = Category.where(id: category_ids).pluck(:name)
  end

  def new
    redirect_to user_path(session[:user_id]) if logged_in?
    @user = User.new
  end

  def create
    @user = User.new(user_params)
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
    session[:user_id] = nil if @user == current_user
    flash[:notice] = "Successfully deleted account."
    redirect_to posts_path
  end

  private

  def get_user
    begin      
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "User not found."
      redirect_to posts_path
    end
  end

  def user_params
    params.require(:user).permit(
      :username, :email, 
      :password, :password_confirmation
    )
  end
  
  def require_same_user
    if current_user != @user && !current_user.is_admin?
      flash[:alert] = "You do not have permission to do that."
      redirect_back fallback_location: @user
    end
  end
end