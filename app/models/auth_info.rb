class AuthInfo < ActiveRecord::Base
  belongs_to :parent, polymorphic: true
  attr_accessor :decrypted_pass

  after_initialize do
    self.salt ||= "abcdefgh" # OpenSSL::Random.random_bytes(8)
  end

  def decrypted_pass
    return @decrypted_pass if @decrypted_pass
    auth_info = KeyVault.unlock(self, User.current)
    @decrypted_pass = auth_info.decrypted_pass
  end

end
