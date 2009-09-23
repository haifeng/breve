#
# Gravatar plugin module extension for Rails ActionView. Will add
# a tag helper for displaying gravatart images.
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
  module ActionView
    # HTML tag helper to display the gravatar of a model;
    # An exception is raised if the model does not mixin the Gravatar module.
    #
    # model::        kind_of? ActiveRecord::Base that mixed in the Gravatar module.
    # options::      Options used to build the URL to access the model's gravatar resource.
    # html_options:: HTML's img tag options.
    def gravatar_for(model, options={}, html_options={})
      html_options[:width] ||= html_options[:height] ||= options[:size]
      attributes = html_options.collect{ |k, v| "#{k}=\"#{v}\"" }.join(' ')
      raise "`model` argument for `gravatar_for` HTML tag helper must extend module Gravatar" unless model.respond_to? :gravatar
      "<img src=\"#{model.gravatar(options)}\" #{attributes} />" 
    end
  end
end
