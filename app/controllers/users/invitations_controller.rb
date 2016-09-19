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
    redirect_to omniauth_authorize_path(:user, :google_oauth2, :state => resource.invitation_token)
  end

  def update
    super
  end

  def destroy
    super
  end
end
