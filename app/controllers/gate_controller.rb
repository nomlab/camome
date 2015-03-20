class GateController < ApplicationController
  skip_before_action :authenticate

  def index
    redirect_to :controller => :welcome, :action => "index"
  end

  def login
    if request.get?
      flash.now[:notice] = "Please login first."
      reset_current_user

    elsif user = User.authenticate(params[:login_name], params[:password])
      flash[:notice] = "User #{user.name} logged in."
      set_current_user(user)

      reset_session_expires
      redirect_to(session[:jumpto] || "/calendars/")

    else
      flash.now[:error] = "Invalid user/passwd."
      reset_current_user
    end
  end

  def logout
    reset_current_user
    reset_session
    redirect_to "/"
  end

end
