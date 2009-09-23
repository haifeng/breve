#
# Gravatar plugin module extension for Rails ActiveRecord.
#
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
  module ActiveRecord
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      # Specify this +has_gravatar+ extension if you want the model to access
      # the methods in the Gravatar::Attributes module
      #
      # options:: Options used to build the URL to access the model's gravatar resource.
      #           the following fields are recognized:
      #   * attr::     The name of the attribute that represents the email address associated with the gravatar (defaults to :email)
      #   * size::     The gravatart image size used (defaults to 80)
      #   * rating::   The gravatar image rating used (defaults to 'g')
      #   * default::  The gravatar default image used when no gravatar is available (defaults to 'default')
      #                The URI of the default image may also be specified (see: http://en.gravatar.com/site/implement/url)
      def has_gravatar(options={})
        class_eval <<-EOV
          @@gravatar_options = {
            :attr    => :email,
            :size    => 80,
            :rating  => Attributes::Rating::G,
            :default => Attributes::DefaultImage::GRAVATAR
          }

          @@gravatar_options.update(options) if options.is_a?(Hash)
          mattr_reader :gravatar_options
          
          include Gravatar::Attributes
        EOV
      end
    end
  end
end
