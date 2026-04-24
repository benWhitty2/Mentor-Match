require 'digest'

class Admin < Sequel::Model

  def loadRegister(params)
    self.pass = params.fetch("password", "").strip
    self.email = params.fetch("email_address", "").strip
  end
  
  def encrypt(password)
    # Set up AES for encryption.
    aes = OpenSSL::Cipher.new('AES-128-CBC').encrypt
    # Generate a random iv
    self.iv = Sequel.blob(aes.random_iv)
    # Generate a random salt.
    self.salt = Sequel.blob(OpenSSL::Random.random_bytes(16))
   
    # Get the key from the password and salt.
    aes.key = OpenSSL::PKCS5.pbkdf2_hmac_sha1(password, salt, 20_000, 16)
   
    # Encrypt the data
    self.pass = Sequel.blob(aes.update(password) + aes.final)

    true
  end
  def compare(password)

    aes = OpenSSL::Cipher.new('AES-128-CBC').encrypt
    aes.iv = self.iv
    aes.key = OpenSSL::PKCS5.pbkdf2_hmac_sha1(password, self.salt, 20_000, 16)

    if Sequel.blob(aes.update(password) + aes.final) == self.pass
      return true
    else
      return false
    end
  end

  def loadProfile(sur_n)
    self.surname = sur_n.strip()
  end


end