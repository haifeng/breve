require 'uri'
require 'net/http'

module Recaptcha
  def Recaptcha.verify(privatekey, remoteip, params={})
    return true if Rails.env.development?
    
    params = {
      :privatekey => privatekey,
      :remoteip => remoteip,
      :response => params[:recaptcha_response_field],
      :challenge => params[:recaptcha_challenge_field] 
    }
    response = Net::HTTP.post_form(URI.parse('http://api-verify.recaptcha.net/verify'), params)
    flag, status = response.body.split("\n")
    case
      when flag =~ /^true$/
        return true
      when status =~ /^(invalid-site-public-key|invalid-request-cookie|verify-params-incorrect|invalid-referrer)$/
        raise RecaptchaError.new(status)
      when status =~ /^(unknown|recaptcha-not-reachable)$/
        raise RecaptchaException.new(status)
      when status =~ /^incorrect-captcha-sol$/
        return false
      else
        raise RecaptchaError.new
    end
  end
  
  class RecaptchaError < Exception; end
  class RecaptachException < Exception; end
  
  def self.diagnose(flag, status)
    flag =~ /^true$/ ? { :message => 'OK' } : DIAGNOSIS[status.to_sym] 
  end

  DIAGNOSIS = { :unknown => { :message => 'Unknown error.' },
    :'invalid-site-public-key' => { :message => 'We weren\'t able to verify the public key.', :tips => 
      ['Did you swap the public and private key? It is important to use the correct one.',
       'Did you make sure to copy the entire key, with all hyphens and underscores, but without any spaces? The key should be exactly 40 letters long.'] },
    :'invalid-site-private-key' => { :message => 'We weren\'t able to verify the private key.', :tips => [
      'Did you swap the public and private key? It is important to use the correct one.',
      'Did you make sure to copy the entire key, with all hyphens and underscores, but without any spaces? The key should be exactly 40 letters long.'] },
    :'invalid-request-cookie' => { :message => 'The challenge parameter of the verify script was incorrect.' },
    :'incorrect-captcha-sol' => { :message => '	The CAPTCHA solution was incorrect.' },
    :'verify-params-incorrect' => { :message => 'The parameters to /verify were incorrect, make sure you are passing all the required parameters.' },
    :'invalid-referrer' => { :message => 'reCAPTCHA API keys are tied to a specific domain name for security reasons. See above for tips on this matter.' },
    :'recaptcha-not-reachable' => { :message => 'reCAPTCHA never returns this error code. A plugin should manually return this code in the unlikely event that it is unable to contact the reCAPTCHA verify server.' } 
  }
end

