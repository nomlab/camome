class Users::RegistrationsController < Devise::RegistrationsController
# before_action :configure_sign_up_params, only: [:create]
# before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  def edit_profile
    @user = current_user
  end

  def edit_applications
  end

  # PUT /resource
  def update
    attr = params.require("user").permit("name","email")
    master_auth_info = MasterAuthInfo.where(:parent_id => @user.id, :parent_type => @user.class.name).first
    current_pass =  params.require("user").permit("password")[:password]
    @user.master_pass = current_pass
    if master_auth_info.encrypted_pass == nil
      valid_pass = true
      KeyVault.lock(master_auth_info, @user)
    else
      auth_info = KeyVault.unlock(master_auth_info, @user)
      if auth_info.decrypted_pass == Digest::SHA1.hexdigest(auth_info.salt + current_pass)
        valid_pass = true
        new_pass = params.require("user").permit("new_password")[:new_password]
        if !new_pass.empty?
          if @user.master_auth_info.token != nil
            auth_info = KeyVault.decrypt_token(auth_info)
            auth_info.decrypted_pass = Digest::SHA1.hexdigest(auth_info.salt + new_pass)
            @user.master_pass = new_pass
            locked_auth_info = KeyVault.lock(auth_info, @user)
            master_auth_info = KeyVault.crypt_token(locked_auth_info, auth_info.decrypted_pass, auth_info.decrypted_token[:token], auth_info.decrypted_token[:refresh_token])
          else
            @user.master_pass = new_pass
            KeyVault.lock(auth_info, @user)
          end
        end
      else
        valid_pass = false
      end
    end
    respond_to do |format|
      if valid_pass && @user.update(attr) && master_auth_info.save
        format.html { redirect_to "/users/edit/profile", notice: 'User was successfully updated.' }
        format.json { render :edit, status: :ok, location: @user }
      else
        format.html { render :edit_profile }
        format.json { render json: @user.errors, status: :unprocessable_entity }
        flash[:error] = "Invalid password."
      end
    end
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
