# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_breve_session',
  :secret      => '2aa9e0a7413f423c65d081a26d38e0f25494f163cb6574fd7d29e01fcd04cc217d0d1f1d89d5019c545013c34180ae6529b914397561e5abdc198e8957e4aad9'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
