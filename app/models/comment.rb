require 'acts_as_post'

class Comment < ActiveRecord::Base
  acts_as_tree
  acts_as_post
  
  validates_presence_of :content
  validates_presence_of :user
  validates_presence_of :commentable
  
  belongs_to :commentable, :polymorphic => true
  belongs_to :user
  
  has_many :votes,    :as => :voteable
  has_many :comments, :as => :commentable
  has_many :comments_by_rank, :as => :commentable, 
    :order => 'rank DESC', :class_name => 'Comment'

  alias :replies :comments
  alias :replies_by_rank :comments_by_rank

  cattr_reader :per_page
  @@per_page = 15
  
  def topic
    @topic ||= self.commentable
    @topic = @topic.commentable until not @topic.respond_to? :commentable
    @topic
  end

  def headline(mode = :full, maxlen = -1)
    @headline = content
    @headline = @headline.truncate(maxlen) if mode == :truncate
    @headline
  end

  # TODO: Refactor (see Post model)
  def self.latest(page)
    paginate :page => page, :order => 'created_at DESC'
  end
  
  # TODO: Refactor (see Post model)
  def self.top_ranked(page)
    paginate :page => page, :order => 'rank DESC'
  end
  
  # TODO: Refactor (see Post model)
  def self.submitted_by(user, page)
    paginate_by_user_id user, :page => page, :order => 'created_at DESC'
  end
  
  # TODO: Refactor (see Post model)
  def self.most_discussed(page)
    paginate :page => page, :order => 'points DESC'
  end
end
