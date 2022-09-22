class CategoriesController < ApplicationController
  
  before_action :require_admin, except: [:index, :show]
  skip_before_action :verify_authenticity_token 

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      # flash[:notice] = "Category was successfully created"
      render json: { message: "Category was successfully created!" }
      #redirect_to @category
    else
      render 'new'
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
      # flash[:notice] = "Category name updated successfully!"
      render json: { message: "Category updated Successfully"}
      #redirect_to @category
    else
      render 'edit'
    end
  end

  def index
    #@categories = Category.paginate(page: params[:page], per_page: 5)
    @categories = Category.all
    #For Postman check
    render json: @categories, status: 200
  end

  def show
    @category = Category.find(params[:id])
    render json: @category

    #@articles = @category.articles.paginate(page: params[:page], per_page: 5)
  end



  private

  def category_params
    params.permit(:name)
  end

  def require_admin
    if !(logged_in? && current_user.admin?)
      # flash[:alert] = "Only admins can perform that action"
      # redirect_to categories_path
      render json: { message: "Only admins can perform that action" }
    end
  end

end