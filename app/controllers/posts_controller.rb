class PostsController < ApplicationController
  acts_as_voter

  before_filter :ensure_user_is_authenticated, 
    :only => [ :new, :create, :edit, :update, :destroy, :vote ]

  def top_ranked
    @posts = Post.top_ranked.paginate(:page => params[:page])
  end

  def latest
    @posts = Post.latest.paginate(:page => params[:page])
  end

  def submitted
    @posts = Post.authored_by(params[:user_id]).paginate(:page => params[:page])
  end

  def voted
    @posts = Post.voted_by(params[:user_id]).paginate(:page => params[:page])
  end

  def new
    @post = Post.new
  end

  def create
    @user = User.find(current_user)
    @post = @user.submit!(params[:post])
    redirect_to latest_posts_url
  rescue DuplicatePostException
    flash[:notice] = "WARN: #{$!.message}, please join the discussion instead."
    redirect_to post_comments_url($!.post)
  rescue PostException
    flash.now[:notice] = "ERROR: #{$!.message}, please try again."
    @post = $!.post
    render :action => :new
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
    @post.update_attributes!(params[:post])
    flash[:notice]     = 'Changes saved.'
    referer            = session['referer']
    session['referer'] = nil
    redirect_to referer
  rescue
    flash.now[:notice] = "ERROR: #{$!.message}, please try again."
    render :action => :edit
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    if @post.frozen?
      redirect_to request.referer
    else
      flash[:notice] = 'WARN: Posts with comments may not be deleted, add a comment on the post instead.'
      redirect_to post_comments_url(@post)
    end
  end
end
