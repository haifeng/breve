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
  before_destroy :ensure_it_has_no_comments

  # Checks if the username and password combination
  # exists in the accounts table.
  def self.authorize(email, password)
    user = self.find :first, :conditions => [ "lower(email) = ?", (email.downcase) ]
    return user if not user.nil? and user.activated? and Password::check(password, user.password) 
  end
  
  def top_ranked_posts
    Post.authored_by(self).top_ranked(5)
  end

  def top_ranked_comments
    Comment.authored_by(self).top_ranked(5)
  end

  # Obfuscate the password field's value on storage
  def password=(plaintext)
    self[:password] = Password::update(plaintext) unless plaintext.blank? 
  end  

  def digest
    self[:password] = ''
    self[:email]    = ''
    self
  end

  def fullname
    @fullname ||= "#{firstname.titleize} #{lastname.titleize}"
  end

  def displayname
    return @displayname          unless @displayname.blank?
    @displayname = self.alias    unless self.alias.blank?
    @displayname = self.fullname if @displayname.blank?
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
    self.posts.sum(:points) - self.posts.count
  end

  def comment_points
    self.comments.sum(:points) - self.comments.count
  end

  def self.configure_for_reset(email)
    user = self.find :first, :conditions => [ "lower(email) = ?", (email.downcase) ]
    unless user.nil?
      user.reset_expires_at = 1.hour.from_now
      user.reset_key        = Password::keystring(BREVE_PRIVATE_KEY, email) 
      user.save
    end
  end

  def self.reset(key, password)
    user = self.reset_allowed?(key)
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

  def self.reset_allowed?(key)
    user = User.find_by_reset_key(key)
    return if user.nil? or user.reset_expires_at < Time.now
    user
  end

  def self.activate(key)
    user = User.find_by_activation_key(key)
    return if user.nil? or user.activation_expires_at < Time.now

    user.activation_key        = nil
    user.activation_expires_at = Time.now

    return unless user.save
    user
  end

  def activated?
    self.activation_key.nil?
  end

  protected
  def configure_for_activation
    self.password              = Password::salt
    self.activation_expires_at = 2.weeks.from_now
    self.activation_key        = Password::keystring(BREVE_PRIVATE_KEY, self.email) 
  end
end
