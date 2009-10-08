require 'digest/md5'
require 'json'
require "uri"
require "net/http"

# Quick and dirty facebook api wrapper
module Facebook
  class API
    def initialize(apikey, secretkey)
      @apikey    = apikey
      @secretkey = secretkey
    end

    protected
    SUPPORTED_METHODS = %w{ users }
    
    def method_missing(sym, *args)
      if @pseudo.nil? and SUPPORTED_METHODS.include? sym.to_s
        @pseudo = "#{sym}."
        return self
      elsif args.first.instance_of?(Hash) and @pseudo =~ /\.$/
        action  = "#{@pseudo}#{sym}"
        params  = args.first
        @pseudo = nil
        return post(action, params)
      end
      super(sym, *args)
    end
    
    private
    def post(action, params)
      params.merge!('method'  => action,
                    'api_key' => @apikey,
                    'call_id' => Time.now.to_i,
                    'v'       => '1.0',
                    'format'  => 'JSON')
      params['sig'] = API::sig(@secretkey, params)
      result        = JSON::parse("{\"data\": #{API::post(params)}}")
      data          = result['data']
      data          = data.first if data.instance_of?(Array) 
      data          = data.inject({}){ |data, (key, value)| data["#{key}".to_sym] = value; data } if data.instance_of?(Hash)
      data
    end

    def self.sig(key, params)
      sig = ''
      params.keys.sort.each { |k| sig << "#{k}=#{params[k]}" }
      Digest::MD5.hexdigest(sig + key)
    end
    
    def self.post(params)
      uri      = URI.parse('http://api.facebook.com/restserver.php')
      response = Net::HTTP.post_form(uri, params)
      response.body
    end
  end
end
