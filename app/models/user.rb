class User < ActiveRecord::Base
  validates_uniqueness_of :nickname, 
    :case_sensitive => false
  validates_presence_of :nickname
  validates_presence_of :password
  validates_uniqueness_of :email, 
    :case_sensitive => false, :allow_blank => true
  validates_format_of :email, 
    :with => /^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}$/i, :allow_blank => true

  has_many :posts
  has_many :submitted_posts, :order => 'created_at desc', 
    :include => [ :author ], :class_name => 'Post'
  has_many :top_ranked_posts, :order => 'rank desc', :limit => 5, 
    :include => [ :author ], :class_name => 'Post'
  has_many :voted_posts, :through => :votes, :include => [ :author ],
    :source => :voteable, :source_type => 'Post'

  has_many :comments
  has_many :submitted_comments, :order => 'created_at desc', 
    :include => [ :author ], :class_name => 'Comment'
  has_many :top_ranked_comments, :order => 'rank desc', :limit => 5, 
    :include => [ :author ], :class_name => 'Comment'
  has_many :voted_comments, :through => :votes, :include => [ :author ],
    :source => :voteable, :source_type => 'Comment'

  has_many :votes
  has_gravatar
  
  # Checks if the username and password combination
  # exists in the accounts table.
  def self.authorize(nickname, password)
    user = self.find :first, :conditions => [ "lower(nickname) = ?", (nickname.downcase) ]
    return user.digest if not user.nil? and Password::check(password, user.password)
  end

  # Obfuscate the password field's value on storage
  def password=(plaintext)
    self[:password] = Password::update(plaintext) unless plaintext.blank? 
  end  

  def digest
    attributes            = self.attributes
    attributes[:id]       = self[:id]
    attributes[:password] = ''
    attributes
  end

  def vote_for(post)
    Vote.cast_for self, post
    post
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
      user.reset_key        = Digest::SHA1.hexdigest("#{user.email}:#{user.reset_expires_at}")
      user.save
    end
  end
  
  def self.reset(reset_key, password)
    user = User.find_by_reset_key(reset_key)
    return if user.nil? or user.reset_expires_at < Time.now
    
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
end
