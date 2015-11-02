RPX_API_KEY = "2bd59b511521b76aac63c917ad6ab2a65b1b5a72"
RPX_APP_NAME = 'knotebooks'
RAILS_GEM_VERSION = '2.3.8' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem 'RedCloth',              :version => '4.2.3'
  config.gem 'acts_as_list',          :version => '0.1.2'
  config.gem 'authlogic',             :version => '2.1.3'
  config.gem 'authlogic_rpx',         :version => '1.1.1'
  config.gem 'haml',                  :version => '2.2.17'
  config.gem 'has_many_polymorphs',   :version => '2.13'
  config.gem 'hoptoad_notifier'
  config.gem 'hpricot',               :version => '0.8.2'
  config.gem 'json',                  :version => '1.2.0'
  config.gem 'rails',                 :version => '2.3.5'
  config.gem 'refraction',            :version => '0.2.0'
  config.gem 'rpx_now',               :version => '~> 0.6.12'
  config.gem 'sunspot',               :version => '1.1.0', :lib => 'sunspot'
  # config.gem 'sunspot_rails',         :version => '1.1.0', :lib => 'sunspot/rails'
  config.gem 'websolr-sunspot_rails', :version => '1.1.0.5'
  # config.gem 'websolr-rails',         :version => '2.4.0'
  config.gem 'will_paginate',         :version => '2.3.12'

  config.time_zone = 'Eastern Time (US & Canada)'
end

# TODO: Find out the RAILS_ENV constant for the webserver
GravatarHelper::DEFAULT_OPTIONS[:default] = "http://knotebooks.com/images/default_gravatar.png"