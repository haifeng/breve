class Vote < ActiveRecord::Base
  validates_presence_of :user
  validates_presence_of :voteable
  
  belongs_to :voteable, :polymorphic => true
  belongs_to :user

  def self.cast_for(user, post)
    # prevent user from voting posts it owns
    return if post.author == user
    
    puts "xx #{user.id} #{user.displayname}  #{post.id} #{post.headline} #{post.class.name}" 

    # toggle user's casted votes for the target post
    # first check if the user has already voted on this post
    vote = self.find_by_user_id_and_voteable_id_and_voteable_type(user, post, post.class.name) 
    unless vote.nil?
      puts ">> #{vote.user_id} #{vote.voteable_id} #{vote.voteable_type}" 
    end
    
    # if not, then create a new vote
    if vote.nil?
      vote = Vote.new do |vote|
        vote.voteable = post
        vote.user     = user
      end
    end
    
    # vote = post.votes.build(:user => user, :voteable => post) if vote.nil?
    # now cast the vote
    self.transaction do
      # if user hasn't voted for the post before
      # then cast the vote...
      if vote.new_record?
        vote.save
        post.increment! :points, vote.value
      # ... otherwise, take the vote back
      else
        post.decrement! :points, vote.value
        vote.delete
      end
    end
  end
end
