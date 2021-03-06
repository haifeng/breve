# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"
  config.gem 'oauth', :version => '0.3.6'
  config.gem 'rdiscount', :version => '1.5.5'
  config.gem 'mislav-will_paginate', :version => '2.3.11', 
    :lib => 'will_paginate', :source => 'http://gems.github.com'
  config.gem 'thoughtbot-pacecar', :version => '1.1.7', 
    :lib => 'pacecar', :source => 'http://gems.github.com'
  config.gem 'facebook', :version => '0.0.1'

  if RUBY_VERSION == '1.8.6' 
    config.gem 'openrain-action_mailer_tls', :verison => '1.1.3', 
      :lib => 'smtp_tls.rb', :source => 'http://gems.github.com'
  end
  
  if ENV['RAILS_ENV'] !~ /^production$/
    config.gem 'thoughtbot-shoulda', 
      :lib => 'shoulda', :source => 'http://gems.github.com'
    config.gem 'thoughtbot-factory_girl', 
      :lib => 'factory_girl', :source => 'http://gems.github.com'
  end
    
  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  config.active_record.observers = [ :user_observer ]

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
  
  # Default options for URL generation in ActionMailer
  config.action_mailer.default_url_options = { :host => 'stark-robot-87.heroku.com' }
end
