class UsersController < ApplicationController
  before_filter :ensure_user_is_authenticated, 
    :only => [ :edit, :update ]
    
  include Recaptcha
  
  def login
    if request.get?
      @user = User.new
    else
      authorize params[:user]
      if authorized?
        referer           = session[:referer] || root_url
        session[:referer] = nil
        redirect_to referer
      else
        @user = User.new(:email => params[:user][:email])
        flash.now[:notice] = 'ERROR: Invalid credentials.' 
      end
    end
  end
  
  def logout
    session[:user] = nil
    redirect_to root_url
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    raise 'CAPTCHA validation failed' unless Recaptcha.verify(RECAPTCHA_PRIVATE_KEY, request.remote_ip, params) 
    if @user.save
      authorize params[:user]
      redirect_to root_url
    else
      raise 'There\'s a problem with your registration'
    end
  rescue
    flash.now[:notice] = "ERROR: #{$!.message}, please try again."
    @user[:password]   = nil
    render :action => :new
  end

  def edit
    @user = User.find current_user
    @user[:password] = nil
  end
  
  def update
    @user = User.find current_user
    if @user.update_attributes(params[:user])
      flash[:notice]   = 'Changes saved.'
      @user[:password] = nil
      session[:user]   = @user.digest
      redirect_to edit_user_url(@user)
    else
      @user[:password]   = nil
      flash.now[:notice] = 'ERROR: There was a problem with your changes, please try again.'
      render :action => :edit
    end
  end
  
  def reset
    case 
    # request password reset
    when request.post?
      email = params[:user][:email]
      if email.blank?
        @user = User.new
        render :action => :login
      else
        User.configure_for_reset(email)
        flash[:notice] = "Reset confirmation sent to #{email}"
        redirect_to login_url
      end
      
    # update password (because of reset request)
    when request.put?
      password =  params[:user][:password]
      @user    = User.reset(params[:key], password) || User.new
      if @user.new_record?
        flash.now[:notice] = 'ERROR: There was a problem with your changes, please try again.'
        render :action => :reset
      else
        flash[:notice] = 'Password changed.'
        authorize(:email => @user.email, :password => password)
        redirect_to edit_user_url(@user)
      end
      
    # edit password (because of reset request)
    when request.get?
      @user = User.find_by_reset_key(params[:key])
      if @user.nil? or @user.reset_expires_at < Time.now
        flash[:notice] = "ERROR: Reset confirmation window expired, please try again."
        redirect_to login_url
      else
        @user[:password] = nil
      end
      
    # shouldn't happen
    else
      redirect_to root_url
    end
  end

  protected
  def authorize(user)
    session[:user] = User.authorize(user[:email], user[:password])
  end
end
