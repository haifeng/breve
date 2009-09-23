require 'acts_as_post'

class Post < ActiveRecord::Base
  acts_as_post
  
  validate :must_have_title_or_narrative
  validates_format_of :url, 
    :with => /^((http|https?):\/\/((?:[-a-z0-9]+\.)+[a-z]{2,}))/i, 
    :allow_blank => true

  belongs_to :user
  belongs_to :section
  
  has_many :votes,    :as => :voteable
  has_many :comments, :as => :commentable
  has_many :comments_by_rank, :as => :commentable, 
    :order => "rank desc", :class_name => 'Comment'

  before_destroy :ensure_action_is_allowed
  before_save :normalize_field_values
  
  cattr_reader :per_page
  @@per_page = 15

  def self.was_submitted_before?(params)
    find_by_url(params[:url]) unless params[:url].blank?
  end
  
  def host
    topic_for_discussion? ? '' : URI.parse(self.url).host
  end
  
  def headline(mode = :full, maxlen = -1)
    @headline = (title.blank? ? content : title)
    @headline = @headline.truncate(maxlen) if mode == :truncate
    @headline
  end
  
  def topic_for_discussion?
    url.blank?
  end

  protected
  def ensure_action_is_allowed
    # TODO: NEED TO IMPLEMENT ensure_action_is_allowed
  end
  
  def normalize_field_values
    self[:url].downcase! unless self[:url].blank?
  end
  
  def must_have_title_or_narrative
    errors.add_to_base("Must at least have a Title or Narrative") if title.blank? and content.blank?
  end
end
