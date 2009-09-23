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
    #           the following fields are recognized:
    #   * attr::     The name of the attribute that represents the email address associated with the gravatar (defaults to :email)
    #   * size::     The gravatart image size used (defaults to 80)
    #   * rating::   The gravatar image rating used (defaults to 'g')
    #   * default::  The gravatar default image used when no gravatar is available (defaults to 'default')
    #                The URI of the default image may also be specified (see: http://en.gravatar.com/site/implement/url)
    def gravatar(options={})
      options[:attr]    ||= :email
      options[:size]    ||= 80
      options[:rating]  ||= Rating::G
      options[:default] ||= DefaultImage::GRAVATAR
      options[:default] = CGI::escape(options[:default]) if options[:default] =~ /^(https?:\/\/|\/)/i 
      email             = "#{self.send(options[:attr])}".downcase
      id                = Digest::MD5.hexdigest(email)
      params            = options.collect{ |k, v| "#{k}=#{v}" }.join('&')
      "#{AVATAR_URL}/#{id}?#{params}"
    end
  end
end

