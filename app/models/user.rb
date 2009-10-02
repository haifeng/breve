class User < ActiveRecord::Base
  validates_presence_of   :email
  validates_uniqueness_of :email, :case_sensitive => false
  validates_format_of     :email, :with => /^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}$/i
  validates_presence_of   :password
  validates_presence_of   :lastname
  validates_presence_of   :firstname
  validates_uniqueness_of :alias, :case_sensitive => false, :allow_blank => true

  has_many :posts
  has_many :comments
  has_many :votes
  
  has_gravatar

  before_validation_on_create :configure_for_activation
  before_save :encrypt_fields

  # Checks if the username and password combination
  # exists in the accounts table.
  def User.authorize(email, password)
    user = find :first, :conditions => [ "email = ?", Password::encrypt(BREVE_PRIVATE_KEY, email.downcase) ]
    return user if not user.nil? and user.activated? and Password::check(password, user.password) 
  end
  
  def top_ranked_posts
    Post.authored_by(self).top_ranked(5)
  end

  def top_ranked_comments
    Comment.authored_by(self).top_ranked(5)
  end

  def password=(value)
    self[:password] = value unless value.blank?
  end
  
  def email=(value)
    if value.blank?
      # HACK: we reassign the decrypted value if argument is blank
      # that way when it gets saved, email is back in plaintext
      # before the encryption is applied
      self[:email] = Password::decrypt(BREVE_PRIVATE_KEY, email)
    else
      self[:email] = value unless value.blank?
    end
  end
  
  def digest
    decrypt_fields
    self
  end

  def fullname
    @fullname ||= "#{firstname.titleize} #{lastname.titleize}"
  end

  def displayname
    if @displayname.blank?
      @displayname = self.alias    unless self.alias.blank?
      @displayname = self.fullname if @displayname.blank?
    end
    @displayname
  end

  def vote_for(post)
    Vote.cast_for self, post
    post
  end

  def submit!(content={})
    post = Post.was_submitted_before?(content[:url])
    raise DuplicatePostException.new(post), 'Duplicate post' unless post.nil?
    
    post = posts.new(content)
    post.save!
    post
  rescue ActiveRecord::RecordInvalid
    raise PostException.new(post), $!.message
  end

  def post_points
    posts.sum(:points) - posts.count
  end

  def comment_points
    comments.sum(:points) - comments.count
  end

  def User.configure_for_reset(email)
    user = find :first, :conditions => [ "email = ?", Password::encrypt(BREVE_PRIVATE_KEY, email.downcase) ]
    unless user.nil?
      user.reset_expires_at = 1.hour.from_now
      user.reset_key        = Password::serial_number(BREVE_PRIVATE_KEY, email) 
      user.save
    end
  end

  def User.reset(key, password)
    user = reset_allowed?(key)
    return if user.nil?

    # when password arg is blank, we clear the password
    # field, we expect the validation for the password
    # field (if any) to take over when the record is
    # being saved
    if password.blank?
      user[:password] = '' 
    else
      user.password         = password 
      user.reset_key        = nil
      user.reset_expires_at = Time.now
    end

    return unless user.save
    user
  end

  def User.reset_allowed?(key)
    user = User.find_by_reset_key(key)
    return if user.nil? or user.reset_expires_at < Time.now
    user
  end

  def User.activate(key)
    user = User.find_by_activation_key(key)
    return if user.nil? or user.activation_expires_at < Time.now

    user.activation_key        = nil
    user.activation_expires_at = Time.now

    return unless user.save
    user
  end

  def activated?
    activation_key.nil?
  end

  protected
  def encrypt_fields
    self[:email]    = Password::encrypt(BREVE_PRIVATE_KEY, email.downcase) unless email.blank?
    self[:password] = Password::update(password) unless password.blank? 
  end
  
  def decrypt_fields
    self[:email]    = Password::decrypt(BREVE_PRIVATE_KEY, email) unless email.blank?
    self[:password] = nil
  end
  
  def configure_for_activation
    self[:password]              = Password::salt
    self[:activation_expires_at] = 2.weeks.from_now
    self[:activation_key]        = Password::serial_number(BREVE_PRIVATE_KEY, email) 
  end
end
