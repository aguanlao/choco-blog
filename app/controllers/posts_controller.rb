class PostsController < ApplicationController
  before_action :get_post, only: [:show, :edit, :update, :destroy]

  def show
  end

  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
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
    redirect_to posts_path
  end

  private

  def get_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :description)
  end
end
