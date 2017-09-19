class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :authenticate
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end

  def google_oauth2
    params = request.env["omniauth.params"]
    token = params["token"]
    state = params["state"]
    auth = request.env["omniauth.auth"]

    case state
    when "invitation"
      user = User.where("invitation_token is ?", token).first
      if user
        User.current = user
        user.provider = auth.provider
        user.auth_name = auth.info.email
        user.save

        master_auth_info = MasterAuthInfo.new()
        user.master_auth_info = master_auth_info
        master_auth_info.save

        sign_in user
        redirect_to '/users/edit'
      else
        flash[:error] = "Invalid invitation token"
        redirect_to '/welcome/index'
      end
    when "application"
      if session[:app_token] == token
        # In the future, we will create CalendarAuthInfo at this timing
        user = current_user
        User.current = user
        auth_info = user.master_auth_info
        auth_info = KeyVault.crypt_token(auth_info, session[:decrypted_pass], auth[:credentials][:token], auth[:credentials][:refresh_token])
        auth_info.save
        redirect_to '/users/edit/applications'
      else
        flash[:error] = "Invalid token"
        redirect_to '/welcome/index'
      end
    when "update"
      if session[:app_token] == token
        user = current_user
        User.current = user
        auth_info = user.master_auth_info
        ds = DataStore::RedisStore.new
        ds.store(user.auth_name, { :token => auth[:credentials][:token], :refresh_token => auth[:credentials][:refresh_token] }.to_json)
        auth_info = KeyVault.crypt_token(auth_info, session[:decrypted_pass], auth[:credentials][:token], auth[:credentials][:refresh_token])
        auth_info.save
        redirect_to '/users/edit/applications'
      else
        flash[:error] = "Invalid token"
        redirect_to '/welcome/index'
      end
    when "login"
      user = User.where(auth_name: auth.info.email).first
      if user
        User.current = user
        sign_in_and_redirect user, :event => :authentication
      else
        flash[:error] = "Your google account has not been registered"
        redirect_to '/welcome/index'
      end
    else
      flash[:error] = "We can't understand the purpose of auth"
      redirect_to '/welcome/index'
    end
  end
end
