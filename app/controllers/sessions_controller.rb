class SessionsController < ApplicationController

  def new
  end


  def check 
    #byebug
    if (session[:user_id] != nil)
      render json: {
      message: 200,
      user: current_user
    }
    else 
      render json:{message:"not ok"} , status: :unprocessable_entity
    end
  end


  def create
    # byebug
    # if session[:user_id] == nil
      user = User.find_by_email(params[:session][:email].downcase)
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
      # flash[:notice]= "Logged in successfully!"
      # redirect_to user
        render json: { message: "Logged in Successfully!" }, status: :created
      else
        render json: { message: "There was something wrong with your login details" }, status: :unprocessable_entity
      end
    # else
      # flash.now[:alert]= "There was something wrong with your login details"
      # render 'new'
      # render json: { message: "You are already logged in"}
    # end
  end

  def destroy 
    if session[:user_id] != nil
      session[:user_id] = nil
    # flash[:notice] = "Logged Out!"
    # redirect_to root_path
      render json: { message: "Logged out successfully! "}
    else
      render json: { message: "You are already logged out" }
    end
  end

end