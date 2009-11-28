# NOTE: we load the dependencies from the lib/ via an initializer
# instead of via the environment.rb because otherwise it wont be loaded
# when we deploy to Heroku.
#
# Ideally, these should be turned into a plugin or packaged as a Gem
#
require 'acts_as_voter'
require 'acts_as_post'
require 'extensions'

require 'exceptions'
require 'appkeys'