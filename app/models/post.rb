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

  before_save :normalize_field_values
  before_destroy :ensure_it_has_no_comments
  
  cattr_reader :per_page
  @@per_page = 15

  def self.was_submitted_before?(url)
    find_by_url(url.downcase) unless url.blank?
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
    if title.blank? and text.blank?
      errors.add_to_base("Must at least have a Title or Text") 
      return false
    end
  end
end
