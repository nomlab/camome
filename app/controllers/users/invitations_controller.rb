class Users::InvitationsController < Devise::InvitationsController
  prepend_before_filter :require_no_authentication, :only => [:update, :destroy]
  skip_before_action :authenticate
  def new
    super
  end

  def create
    super
  end

  def edit
    redirect_to omniauth_authorize_path(:user, :google_oauth2, :token => resource.invitation_token, :state => "invitation")
  end

  def update
    super
  end

  def destroy
    super
  end
end
