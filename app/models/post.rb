class Post < ActiveRecord::Base
  acts_as_post

  validate :must_have_title_or_narrative
  validates_format_of :url, 
    :with => /^((http|https?):\/\/((?:[-a-z0-9]+\.)+[a-z]{2,}))/i, 
    :allow_blank => true
  validates_presence_of :author

  belongs_to :section
  belongs_to :author, :counter_cache => true, 
    :class_name => 'User', :foreign_key => 'user_id'
  
  has_many :votes,    :as => :voteable
  has_many :comments, :as => :commentable
  has_many :comments_by_rank, :as => :commentable, 
    :order => "rank desc", :class_name => 'Comment'

  before_destroy :ensure_it_has_no_comments
  before_save :normalize_field_values
  
  cattr_reader :per_page
  @@per_page = 15

  def self.was_submitted_before?(url)
    find_by_url(url) unless url.blank?
  end

  def self.submit!(author, content={})
    post = Post.was_submitted_before?(content[:url])
    raise DuplicatePostException.new(post), "Duplicate post, please join in the discussion instead." unless post.nil?
    begin
      post        = Post.new(content) 
      post.author = User.find(author)
      post.save!
      post
    rescue
      raise PostException.new(post), $!.message
    end
  end
  
  def host
    topic_for_discussion? ? '' : URI.parse(self.url).host
  end
  
  def topic_for_discussion?
    url.blank?
  end
  
  protected
  def normalize_field_values
    self[:url].downcase! unless self[:url].blank?
  end
  
  def must_have_title_or_narrative
    errors.add_to_base("Must at least have a Title or Text") if title.blank? and text.blank?
  end
end
