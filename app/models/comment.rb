class Comment < ActiveRecord::Base
  acts_as_tree
  acts_as_post
  
  validates_presence_of :text
  validates_presence_of :author
  validates_presence_of :commentable
  
  belongs_to :commentable, :counter_cache => true, :polymorphic => true
  belongs_to :author, :counter_cache => true, 
    :class_name => 'User', :foreign_key => 'user_id'
  
  has_many :votes, :as => :voteable, :dependent => :destroy
  has_many :comments, :as => :commentable

  alias :replies :comments

  before_destroy :ensure_it_has_no_comments

  cattr_reader :per_page
  @@per_page = 15
  
  def topic
    @topic ||= self.commentable
    @topic = @topic.commentable until not @topic.respond_to? :commentable
    @topic
  end
end
