# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  after_filter  :ensure_visit_is_remembered

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  include SessionHelper
  include PathHelper

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  protected

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
  
  def authorize(user)
    create_session_for User.authorize(user[:email], user[:password])
  end

  def create_session_for(user)
    if user.nil?
      session[:user]  = nil
    else
      session[:user]  = user.normalized
    end
    user
  end
  
  alias :update_session_for :create_session_for
end
