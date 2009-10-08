# TODO: Need to device a better way to do these without exposing
# the keys from the public source repo...
#
# Another issue is setting up the keys for devwork - would be nice
# if these services had an equivalent non-live key for each account
#
%w(
  BREVE_PRIVATE_KEY         
  BREVE_PUBLIC_KEY          

  GMAIL_SMTP_PASSWORD
  GMAIL_SMTP_USER
  
  RECAPTCHA_PRIVATE_KEY     
  RECAPTCHA_PUBLIC_KEY     

  TWITTER_CONSUMER_KEY      
  TWITTER_CONSUMER_SECRET   
  TWITTER_REQUEST_TOKEN_URL 
  TWITTER_ACCESS_TOKEN_URL  
  TWITTER_AUTHORIZE_URL     
  TWITTER_URL               
                
  FACEBOOK_APPNAME          
  FACEBOOK_APPLICATION_ID   
  FACEBOOK_CONSUMER_KEY     
  FACEBOOK_CONSUMER_SECRET  
  FACEBOOK_XD_CHANNEL_URL   
                
  GOOGLE_CONSUMER_KEY       
  GOOGLE_CONSUMER_SECRET    
  GOOGLE_URL                
                
  FIREEAGLE_CONSUMER_KEY   
  FIREEAGLE_CONSUMER_SECRET
  FIREEAGLE_GENERAL_PURPOSE_TOKEN
  FIREEAGLE_GENERAL_PURPOSE_SECRET
  FIREEAGLE_URL             

  YAHOO_APPLICATION_ID      
  YAHOO_CONSUMER_KEY        
  YAHOO_CONSUMER_SECRET     
  YAHOO_URL                 

  NETFLIX_CONSUMER_KEY      
  NETFLIX_CONSUMER_SECRET   
  NETFLIX_URL               
).each { |key|
  Object.class_eval <<-EOV
    #{key} = ENV['#{key}']
  EOV
}
