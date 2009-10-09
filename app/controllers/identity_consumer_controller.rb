class IdentityConsumerController < ApplicationController
  def login
    provider = params[:provider]
    consumer = @@consumer[provider.to_sym]
    send("#{provider}_login", consumer)
  end
  
  def callback
    provider = params[:provider]
    consumer = @@consumer[provider.to_sym]
    send("#{provider}_callback", consumer)
  end
  
  protected
  def twitter_login(consumer)
    @request_token = consumer.get_request_token(
      :oauth_callback => identity_callback_url(:provider => 'twitter'))
    
    session[:oauth_token]        = @request_token.token 
    session[:oauth_token_secret] = @request_token.secret
    
    redirect_to @request_token.authorize_url
  end
  
  def twitter_callback(consumer)
    if params[:denied].blank?
      @request_token = OAuth::RequestToken.new(consumer, 
        session[:oauth_token], session[:oauth_token_secret])
      @access_token = @request_token.get_access_token(
        :oauth_verifier => params[:oauth_verifier])

      response = @access_token.get('/account/verify_credentials.json')
      raise 'Service denied access.' unless response.instance_of? Net::HTTPOK

      data        = JSON.parse(response.body)
      fn, ln      = data['name'].split
      credentials = { :firstname => fn, :lastname  => ln || data['screen_name'] }
      @user       = User.from_identity(data['id'].to_s, 'twitter.com', credentials)
      update_session_for @user
      
      referer           = session[:referer] || root_url
      session[:referer] = nil
      redirect_to referer
    else
      redirect_to login_url
    end
  rescue
    flash[:notice] = "ERROR: #{$!.message}"
    redirect_to login_url
  end

  def facebook_callback(consumer)
    api  = Facebook::API.new(consumer[:consumer_key], consumer[:consumer_secret])
    data = api.users.getLoggedInUser('session_key' => params[:session_key])
    raise "Service denied access." unless params[:uid] =~ /^#{data}$/
    
    data        = api.users.getStandardInfo('uids' => params[:uid], 'fields' => 'uid, proxied_email, first_name, last_name, username, name')
    credentials = { :firstname => data[:first_name], :lastname  => data[:last_name] }
    @user       = User.from_identity(data[:uid].to_s, 'facebook.com', credentials)
    update_session_for @user
    
    referer           = session[:referer] || root_url
    session[:referer] = nil
    redirect_to referer
  rescue
    flash[:notice] = "ERROR: #{$!.message}"
    redirect_to login_url
  end
  
  #def google_login(consumer)
  #  @request_token = consumer.get_request_token(
  #    { :oauth_callback => identity_callback_url(:provider => 'google') },
  #    { :scope => 'http://www.google.com/base/feeds/' })
  #  
  #  session[:oauth_token]        = @request_token.token 
  #  session[:oauth_token_secret] = @request_token.secret
  #  
  #  redirect_to @request_token.authorize_url
  #end

  #def google_callback(consumer)
  #  raise 'User denied access.' unless params[:denied].blank?
  #
  #  @request_token = OAuth::RequestToken.new(consumer, 
  #    session[:oauth_token], session[:oauth_token_secret])
  #  @access_token = @request_token.get_access_token(
  #    :oauth_verifier => params[:oauth_verifier])
  #
  #  response = @access_token.get('https://www.google.com/base/feeds/')
  #  raise 'Service denied access.' unless response === Net::HTTPSuccess
  #  
  #  credentials       = JSON.parse(response.body)
  #  referer           = session[:referer] || root_url
  #  session[:referer] = nil
  #  redirect_to referer
  #rescue
  #  flash[:notice] = "ERROR: #{$!.message}"
  #  redirect_to root_url
  #end
  
  @@consumer = {
    :facebook => { 
      :consumer_key    => FACEBOOK_CONSUMER_KEY,
      :consumer_secret => FACEBOOK_CONSUMER_SECRET },
    :twitter => OAuth::Consumer.new(
      TWITTER_CONSUMER_KEY, 
      TWITTER_CONSUMER_SECRET, 
      :site => TWITTER_URL)
    #:google => OAuth::Consumer.new(
    #  GOOGLE_CONSUMER_KEY, 
    #  GOOGLE_CONSUMER_SECRET, 
    #  :site               => GOOGLE_URL,
    #  :signature_method   => 'RSA-SHA1',
    #  :request_token_path => '/accounts/OAuthGetRequestToken',
    #  :authorize_path     => '/accounts/OAuthAuthorizeToken',
    #  :access_token_path  => '/accounts/OAuthGetAccessToken',
    #  :private_key_file   => "#{RAILS_ROOT}/config/resources/rsakey.pem"),
    #:fireeagle => OAuth::Consumer.new(
    #  FIREEAGLE_CONSUMER_KEY, 
    #  FIREEAGLE_CONSUMER_SECRET, 
    #  :site => FIREEAGLE_URL,
    #  :authorize_url => 'https://fireeagle.yahoo.net/oauth/authorize'),
    #:yahoo => OAuth::Consumer.new(
    #  YAHOO_CONSUMER_KEY, 
    #  YAHOO_CONSUMER_SECRET, 
    #  :site => YAHOO_URL,
    #  :request_token_path => '/oauth/v2/get_request_token',
    #  :authorize_path     => '/oauth/v2/request_auth',
    #  :access_token_path  => '/oauth/v2/get_token')
  }
end
