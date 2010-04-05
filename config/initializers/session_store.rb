# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_zillow1_session',
  :secret      => 'f198ff5600f30a2b1c1bfedeeaf645fe55daf7a001db91abc75c67117afeb57e59cfd19280e7aa123fe7fbc8d3f31ff7b694de51b63778cc59fda681ad75cd14'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
