require 'cucumber/rails/rspec'

# Add machinist
require File.join(RAILS_ROOT, 'spec', 'blueprints')
Dir[[RAILS_ROOT, 'spec', 'helpers', '*.rb'].join('/')].each { |file| require file }
