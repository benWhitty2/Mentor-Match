require 'digest'

class Mentee < Sequel::Model

  def loadRegister(params)
    self.username = params.fetch("username", "").strip
    self.pass = params.fetch("password", "").strip
    self.email = params.fetch("email_address", "").strip
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
    

  def loadProfile(first_n, sur_n, dofb, bio, course)
    self.first_name = first_n.strip()
    self.surname = sur_n.strip()
    self.date_of_birth = dofb.strip()
    self.bio = bio.strip()
    self.course = course.strip()
  end

  def yearInit
    if self.year_of_study == nil
      self.year_of_study = 0
    end
  end

  def flagInit
    if self.flagged == nil
      self.flagged = 0
    end
  end

  def pfpInit
    if self.photo_file == nil
      self.photo_file = "pfp-placeholder.jpg"
    end
  end
  
  def name
    "#{first_name} #{surname}"
  end
end