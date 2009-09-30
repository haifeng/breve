class CommentsController < ApplicationController
  acts_as_voter
  
  before_filter :ensure_user_is_authenticated, 
    :only => [ :new, :create, :reply, :edit, :update, :destroy, :vote ]
    
  def top_ranked
    @comments = Comment.top_ranked(params[:page])
  end

  def submitted
    @comments = Comment.submitted_by(params[:user_id], params[:page])
  end

  def voted
    @comments = Comment.voted_by(params[:user_id], params[:page])
  end
    
  def index
    @post     = find_commentable
    @comments = @post.comments_by_rank
  end

  def create
    @post = find_commentable
    attach_comment_to @post
    redirect_to comments_path_for(@post)
  end

  def reply
    @comment = Comment.find(params[:id])
    @post    = @comment.topic
    if request.post? 
      attach_reply_to @comment
      redirect_to comments_path_for(@post)
    else
      render :layout => 'facebox'
    end
  end
  
  def edit
    @comment = Comment.find(params[:id])
    if not @comment.replies.empty?
      flash[:notice] = 'Comments with replies may not be edited, reply to the comment instead.'
      redirect_to reply_comment_url(@comment)
    else
      render :layout => 'facebox'
    end
  end
  
  def update
    @comment = Comment.find(params[:id])
    @comment.update_attributes!(params[:comment])
    flash[:notice] = 'Changes saved.'
  rescue
    flash.now[:notice] = "ERROR: #{$!.message}, please try again."
  ensure
    redirect_to comments_path_for(@comment.topic)
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    if @comment.frozen?
      redirect_to request.referer
    else
      flash[:notice] = 'WARN: Comments with replies may not be deleted.'
      redirect_to post_comments_url(@comment.topic)
    end
  end
  
  protected
  def find_commentable  
    params.each { |name, value|  
      return $1.classify.constantize.find(value)  if name =~ /(.+)_id$/  
    } 
    nil 
  end

  def attach_comment_to(post)
    comment = Comment.new(params[:comment]) do |comment|
      comment.commentable = post
      comment.parent      = post if post.instance_of? Comment
      comment.author      = User.find(current_user)
    end
    comment.save! rescue flash.now[:notice] = "ERROR: #{$!.message}, please try again."
  end
  
  alias :attach_reply_to :attach_comment_to
end
