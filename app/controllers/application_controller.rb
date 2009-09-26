# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  after_filter  :ensure_visit_is_remembered

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  helper_method :current_user, 
    :authorized?,
    :edit_path_for,
    :path_for_model,
    :vote_path_for,
    :reply_to_comment_for_topic_path_for,
    :comments_path_for

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  protected
  def authorized?
    not session[:user].nil?
  end
  
  def current_user(field = :id)
    return '' if session[:user].nil?
    session[:user].send(field)
  end

  # filters
  
  def ensure_visit_is_remembered
    return unless cookies[:site].nil?
    cookies[:site] = {
      :value   => true,
      :expires => 1.year.from_now
    }
  end

  def ensure_user_is_authenticated
    return if authorized?
    flash[:notice]    = 'ERROR: You need to be logged-in first.'
    session[:referer] = request.referer
    redirect_to login_url
  end
  
  # helpers
  
  def path_for_model(post)
    send("#{post.class.name.downcase}_path", post)
  end

  def edit_path_for(post)
    send("edit_#{post.class.name.downcase}_path", post)
  end
  
  def vote_path_for(post)
    send("vote_#{post.class.name.downcase}_path", post)
  end

  def comments_path_for(post)
    send("#{post.class.name.downcase}_comments_path", post)
  end

  def reply_to_comment_for_topic_path_for(post)
    send("reply_#{post.topic.class.name.downcase}_comment_path", 
      post.commentable, post)
  end
end
