class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_user, only: [:edit, :update, :destroy]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  skip_before_action :verify_authenticity_token 

  def show
    #@articles = @user.articles.paginate(page: params[:page], per_page: 5)
    @articles = @user.articles

    render json: @user, status: 200
    #For Postman check
    #render json: @articles, status: 200
  end

  def index
    #@users = User.paginate(page: params[:page], per_page: 5)

    @users = User.all
    #For Postman check
    render json: @users, status: 200
  end

  def new
    @user = User.new
  end

  def edit
  end

  def update
    if @user.update(user_params)
      #flash[:notice] = "Your account information was successfully updated!"
      render json: { message: "Updated successfully" }
      #redirect_to @user
    else
      render json:{ error: "not updated" }
    end
  end

  def create
    if ( session[:user_id] == nil)
      @user = User.new(user_params)
      if @user.save
        session[:user_id] = @user.id
        render json: @user

        flash[:notice] = "Welcome to Alpha Blog '#{@user.username}', you have successfully signed up"
        #redirect_to articles_path
      else
        render 'new'
      end
    else
      render json: { message: "You need to log out to create a new user"}
    end
  end

  def destroy
    if @user.destroy
      render json: { message: "User Deleted Successfully!"}
    else
      render json: { error: "User does not exists" }
    end
    # session[:user_id] = nil if @user == current_user
    # flash[:notice] = "Account and all associated articles successfully deleted"
    #redirect_to articles_path
  end

  private
  def user_params
    # params.require(:user).permit(:username, :email, :password, :admin)
    params.permit(:username, :email, :password, :admin)
  end

  def set_user
    # @user = User.find(params[:id])
    if ( User.find_by_id(params[:id]) )
      @user = User.find(params[:id])
      #render json: @user
    else
        render json: { error: "Id not exists" }
    end
  end

  def require_same_user
    if current_user != @user && !current_user.admin?
      render json: { message: "You can only edit or delete your own account's profile" }
      # flash[:alert] = "You can only edit or delete your own account's profile"
      # redirect_to @user
    end
  end
end