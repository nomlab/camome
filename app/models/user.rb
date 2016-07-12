class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  has_many :calendars, dependent: :destroy
  has_one :auth_info, as: :parent,
  class_name: "MasterAuthInfo", dependent: :destroy

  attr_accessor :master_pass

  def self.current=(member)
    @current_member = member
  end

  def self.current
    @current_member
  end

  def self.authenticate(login_name, password)
    auth_info = MasterAuthInfo.where(["login_name=?", login_name]).first
    return nil unless auth_info
    user = auth_info.parent
    user.master_pass = password
    begin
      auth_info = KeyVault.unlock(user.auth_info, user)
      registed_hash = auth_info.decrypted_pass
      calculated_hash = Digest::SHA1.hexdigest(user.auth_info.salt + user.master_pass)
      if registed_hash == calculated_hash
        user.auth_info = auth_info
        return user
      end
    rescue
      return nil
    end
    return nil
  end

  def self.find_for_google_oauth2(auth)
    user = User.where(email: auth.info.email).first

    unless user
      user = User.create(name:     auth.info.name,
                         provider: auth.provider,
                         uid:      auth.uid,
                         email:    auth.info.email,
                         token:    auth.credentials.token,
                         password: Devise.friendly_token[0, 20])
    end
    user
  end
end
