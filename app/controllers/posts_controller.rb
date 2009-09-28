class PostsController < ApplicationController
  acts_as_voter

  before_filter :ensure_user_is_authenticated, 
    :only => [ :new, :create, :edit, :update, :destroy, :vote ]

  def new
    @post = Post.new
  end

  def create
    @user = User.find current_user
    if @post = Post.was_submitted_before?(params[:post])
      flash[:notice] = 'WARN: Someone already submitted the same thing, please join in the discussion instead.'
      redirect_to post_comments_url(@post)
      return
    end
    
    @post        = Post.new(params[:post]) 
    @post.author = @user
    if @post.save
      redirect_to latest_posts_url
    else
      flash.now[:notice] = 'ERROR: There was a problem with your post, please try again.'
      render :action => :new
    end
  end
  
  def edit
    session['referer'] ||= request.referer
    @post = Post.find(params[:id])
    if not @post.comments.empty?
      flash[:notice] = 'WARN: Posts with comments may not be edited, add a comment on the post instead.'
      redirect_to post_comments_url(@post)
    end
  end
  
  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(params[:post])
      flash[:notice]     = 'Changes saved.'
      referer            = session['referer']
      session['referer'] = nil
      redirect_to referer
    else
      flash.now[:notice] = 'ERROR: There was a problem with your changes, please try again.'
      render :action => :edit
    end
  end

  def top_ranked
    @posts = Post.top_ranked(params[:page])
  end
  
  def latest
    @posts = Post.latest(params[:page]) 
  end
  
  def submitted
    @posts = Post.submitted_by(params[:user_id], params[:page])
  end
  
  def voted
    @posts = Post.voted_by(params[:user_id], params[:page])
  end
  
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    if @post.frozen?
      redirect_to request.referer
    else
      flash[:notice] = 'WARN: Posts with comments may not be deleted, add a comment on the post instead.'
      redirect_to post_comments_url(@post)
      return
    end
  end
end
