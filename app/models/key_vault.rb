class KeyVault
  def self.lock(auth_info, user)
    case auth_info.type
    when "MasterAuthInfo"
      auth_info.encrypted_pass =
        crypt_word(Digest::SHA1.hexdigest(auth_info.salt + user.master_pass),
                   user.master_pass,
                   auth_info.salt).unpack("H*").join
    else
      auth_info.encrypted_pass =
        crypt_word(auth_info.decrypted_pass,
                   user.master_auth_info.decrypted_pass,
                   auth_info.salt).unpack("H*").join
    end

    return auth_info
  end

  def self.unlock(auth_info, user)
    case auth_info.type
    when "MasterAuthInfo"
      auth_info.decrypted_pass =
        decrypt_word([auth_info.encrypted_pass].pack("H*"),
                     user.master_pass,
                     auth_info.salt)
    else
      auth_info.decrypted_pass = 
        decrypt_word([auth_info.encrypted_pass].pack("H*"),
                     user.master_auth_info.decrypted_pass,
                     auth_info.salt)
    end
    return auth_info
  end

  def self.crypt_token(auth_info, user, token, refresh_token)
    auth_info.token =
      crypt_word(token,
                 user.master_pass,
                 auth_info.salt).unpack("H*").join

    auth_info.refresh_token =
      crypt_word(refresh_token,
                 user.master_pass,
                 auth_info.salt).unpack("H*").join

    return auth_info
  end

  def self.decrypt_token(auth_info, user)
    auth_info.decrypted_token = {}
    auth_info.decrypted_token[:token] =
      decrypt_word([auth_info.token].pack("H*"),
                   user.master_pass,
                   auth_info.salt)
    
    auth_info.decrypted_token[:refresh_token] =
      decrypt_word([auth_info.refresh_token].pack("H*"),
                   user.master_pass,
                   auth_info.salt)
    
    return auth_info
  end

  def self.crypt_word(word, secret_key, salt)
    cipher = OpenSSL::Cipher::Cipher.new("AES-256-CBC")
    cipher.encrypt
    cipher.pkcs5_keyivgen(secret_key, salt)
    cipher.update(word) + cipher.final
  end
  private_class_method :crypt_word

  def self.decrypt_word(word, secret_key, salt)
    cipher = OpenSSL::Cipher::Cipher.new("AES-256-CBC")
    cipher.decrypt
    cipher.pkcs5_keyivgen(secret_key, salt)
    cipher.update(word) + cipher.final
  end
  private_class_method :decrypt_word
end
