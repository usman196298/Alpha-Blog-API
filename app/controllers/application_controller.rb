class ApplicationController < ActionController::Base

  helper_method :current_user, :logged_in?
  helper_method :current_user
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_user
    if !logged_in?
      # flash[:alert] = "You must be logged in to perform that action"
      # redirect_to login_path
      render json: { message: "You must be logged in to perform that action" }
    end
  end

end
