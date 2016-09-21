class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate

  def authenticate
    return true if user_signed_in?

    session[:jumpto] = request.parameters
    redirect_to "/welcome/index"
    return false
  end
end
