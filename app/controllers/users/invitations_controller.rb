class Users::InvitationsController < Devise::InvitationsController
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
