class AuthInfo < ActiveRecord::Base
  belongs_to :parent, polymorphic: true
  attr_accessor :decrypted_pass

  after_initialize do
    self.salt ||= "abcdefgh" # OpenSSL::Random.random_bytes(8)
  end
end
