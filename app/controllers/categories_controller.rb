class CategoriesController < ApplicationController
  before_action :get_category, only: [:show, :edit, :update, :destroy]
  before_action :require_admin, except: [:show, :index]
  
  def show
    @posts = Post.joins(:categories).where(categories: { id: @category.id }).
      order(created_at: :desc).page(params[:page]).per(5)
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

  def edit
  end

  def update
    if @category.update(category_params)
      flash[:notice] = "Category updated successfully."
      redirect_to @category
    else
      render 'edit'
    end
  end

  def destroy
    @category.destroy
    flash[:notice] = "Category '#{@category.name}' deleted."
    redirect_to categories_path
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