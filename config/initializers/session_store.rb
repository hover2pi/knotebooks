# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_knotebooks-rewrite_session',
  :secret      => '30d843bf10ec77763ed2d66fce8f1796211035a4000521638739495df1dad396c2b5c777958c93bbe162a2ff748a399b091690db8602b62169e46b339878807e'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
