class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token 


  def new
  end

  def create
    if session[:user_id] == nil
      user = User.find_by(email: params[:session][:email].downcase)
      if user && user.authenticate(params[:session][:password])
        session[:user_id] = user.id
      # flash[:notice]= "Logged in successfully!"
      # redirect_to user
        render json: { message: "Logged in Successfully!" }
      else
        render json: { message: "There was something wrong with your login details" }
      end
    else
      # flash.now[:alert]= "There was something wrong with your login details"
      # render 'new'
      render json: { message: "You are already logged in"}
    end
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