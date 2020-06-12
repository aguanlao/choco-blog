class CategoriesController < ApplicationController
  before_action :get_category, only: [:show]
  before_action :require_admin, except: [:show, :index]
  
  def show
    @posts = Post.joins(:categories).where(categories: { id: @category.id }).
      order(created_at: :desc).page(params[:page]).per(3)
  end
  
  def index
    @categories = Category.all
  end
  
  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:notice] = "Category created successfully."
      redirect_to @category
    else
      render 'new'
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def get_category
    begin
      @category = Category.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "Category not found."
      redirect_to categories_path
    end
  end
end