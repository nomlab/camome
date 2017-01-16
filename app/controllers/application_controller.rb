class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, if: -> {authenticate_by_token}
  before_filter :authenticate

  def authenticate
    return true if user_signed_in?

    session[:jumpto] = request.parameters
    redirect_to "/welcome/index"
    return false
  end

  private

  def authenticate_by_token
    return false if params[:api_token].blank?
    user = User.find_by("api_token IS ?", "#{params[:api_token]}")
    if user
      sign_in user
      return true
    else
      return false
    end
  end
end
