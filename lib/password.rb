require 'openssl'
#require 'digest/sha2'
require 'base64'

# This module contains functions for hashing and storing passwords
module Password
  # Generates a new salt and rehashes the password
  def Password.update(password)
    salt = self.salt
    hash = self.hash(password, salt)
    self.store(hash, salt)
  end

  # Checks the password against the stored password
  def Password.check(password, store)
    hash = self.get_hash(store)
    salt = self.get_salt(store)
    self.hash(password, salt) == hash
  end

  # Concatenates values to generate a key serial number
  def Password.serial_number(*values)
    Digest::SHA2.hexdigest("#{values.join}:#{Password.salt}")
  end

  # Encrypt text with key
  # TODO: should use an IV later
  def Password.encrypt(key, text)
    c = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
    c.encrypt
    c.key = key = Digest::SHA256.digest(key)
    #c.iv = iv = c.random_iv
    e = c.update(text)
    e << c.final
    #[ e, iv ]
    Base64.encode64(e)
  end
  
  # Decrypt text with key
  # TODO: should use an IV later
  def Password.decrypt(key, text)
    c = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
    c.decrypt
    c.key = Digest::SHA256.digest(key)
    # c.iv = iv
    d = c.update(Base64.decode64(text))
    d << c.final
    d
  end

  protected
  # Generates a psuedo-random 64 character string
  def Password.salt
    salt = ""
    64.times { salt << (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61 ))).chr }
    salt
  end

  # Generates a 128 character hash
  def Password.hash(password, salt)
    Digest::SHA512.hexdigest("#{password}:#{salt}")
  end
  
  # Mixes the hash and salt together for storage
  def Password.store(hash, salt)
    hash + salt
  end

  # Gets the hash from a stored password
  def Password.get_hash(store)
    store[0..127]
  end

  # Gets the salt from a stored password
  def Password.get_salt(store)
    store[128..192]
  end
end
