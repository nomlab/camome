class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :invitable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  has_many :calendars, dependent: :destroy
  has_one :master_auth_info, as: :parent, dependent: :destroy

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
      auth_info = KeyVault.unlock(user.master_auth_info, user)
      registed_hash = auth_info.decrypted_pass
      calculated_hash = Digest::SHA1.hexdigest(user.master_auth_info.salt + user.master_pass)
      if registed_hash == calculated_hash
        user.master_auth_info = auth_info
        return user
      end
    rescue
      return nil
    end
    return nil
  end
end
