#
# Mixin for ActiveRecord::Base classes. Will add a gravatar(..) method
# which returns the URL of the gravatar resource associated to the model's
# instance.
#
# Author::    Juris Galang (mailto:jurisgalang@gmail.com)
# Copyright:: Copyright (c) 2009 Juris Galang
# License::   MIT License
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
module Gravatar
  module Attributes
    AVATAR_URL = "http://www.gravatar.com/avatar"

    module Rating
      G  = 'g'
      PG = 'pg'
      R  = 'r'
      X  = 'x'
    end

    module DefaultImage
      GRAVATAR  = 'd'
      IDENTICON = 'identicon'
      MONSTERID = 'monsterid'
      WAVATAR   = 'wavatar'
    end

    # Return the gravatar URL associated with the model's instance.
    # options:: Options used to build the URL to access the model's gravatar resource.
    #           This will override the options specified in the +has_gravatar+ declaration.
    def gravatar(options={})
      configuration = gravatar_options

      configuration.update(options) if options.is_a? Hash
      if configuration[:default] =~ /^(https?:\/\/|\/)/i 
        configuration[:default] = CGI::escape(configuration[:default]) 
      end

      email  = "#{self.send(configuration[:attr])}".downcase
      id     = Digest::MD5.hexdigest(email)
      params = configuration.collect{ |k, v| "#{k}=#{v}" }.join('&')
      "#{AVATAR_URL}/#{id}?#{params}"
    end
  end
end
