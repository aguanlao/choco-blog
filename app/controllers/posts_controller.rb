class PostsController < ApplicationController
  before_action :get_post, only: [:show, :edit, :update, :destroy]
  before_action :require_user, except: [:show, :index]
  before_action :require_post_user, only: [:edit, :update, :destroy]

  def show
  end

  def index    
    if Post.count > 3      
      @posts = Post.order(created_at: :desc).page(params[:page]).
        per(3).padding(3)
      @featured_posts = Post.order(created_at: :desc).first(3)
    else      
      @posts = Post.order(created_at: :desc).page(params[:page]).per(3)
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    # Try to save new post & display success message, else show error
    if @post.save
      flash[:notice] = "Post created successfully."
      redirect_to @post
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    # Try to update post & display proper feedback message
    if @post.update(post_params)
      flash[:notice] = "Post was updated successfully."
      redirect_to @post
    else
      render 'edit'
    end
  end

  def destroy
    @post.destroy
    flash[:notice] = "Post ##{@post.id} deleted."
    if params[:user]
      redirect_back fallback_location: posts_path
      return
    end
    redirect_to posts_path
  end

  private

  def get_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :description)
  end

  def require_post_user
    if current_user != @post.user && !current_user.is_admin?
      flash[:alert] = "You do not have permission to do that."
      redirect_back fallback_location: @post
    end
  end
end
