class CommentsController < ApplicationController
  acts_as_voter
  
  before_filter :ensure_user_is_authenticated, 
    :only => [ :new, :create, :reply, :edit, :update, :destroy, :vote ]
    
  def submitted
    @comments = Comment.submitted_by(params[:user_id], params[:page])
  end

  def voted
    @comments = Comment.voted_by(params[:user_id], params[:page])
  end

  def top_ranked
    @comments = Comment.top_ranked(params[:page])
  end
  
  def index
    @post     = find_commentable
    @comments = @post.comments
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
    @comment       = Comment.find(params[:id])
    flash[:notice] = 'Changes saved.' if @comment.update_attributes(params[:comment])
    redirect_to comments_path_for(@comment.topic)
  end

  def destroy
    @comment = Comment.find(params[:id])
    if not @comment.replies.empty?
      flash[:notice] = 'WARN: Comments with replies may not be deleted.'
      redirect_to post_comments_url(@comment.topic)
      return
    end
    @comment.destroy
    redirect_to request.referer
  end
  
  protected
  def find_commentable  
    params.each { |name, value|  
      return $1.classify.constantize.find(value)  if name =~ /(.+)_id$/  
    } 
    nil 
  end

  def attach_comment_to? post
    if params[:comment][:content].blank?
      false
    else
      comment = Comment.new(params[:comment]) do |comment|
        comment.commentable = post
        comment.parent      = post if post.instance_of? Comment
        comment.author      = User.find(current_user)
      end
      attached = comment.save!
      flash.now[:notice] = 'ERROR: Unable to save comment, please try again.' unless attached
      attached
    end
  end
  
  alias :attach_reply_to?  :attach_comment_to?
  alias :attach_reply_to   :attach_comment_to?
  alias :attach_comment_to :attach_comment_to?
end
