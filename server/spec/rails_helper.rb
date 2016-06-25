ENV['RAILS_ENV'] ||= 'test'
require_relative './support/coverage' # Load coverage stuff early
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort('The Rails environment is in production mode!') if Rails.env.production?

require 'spec_helper'
require 'rspec/rails'
# Rails is now loaded

# Require supporting ruby files in spec/support
# Do not end their names in _spec, or it'll bug out
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Check for pending migrations before tests are run
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # Run each example in a transaction
  config.use_transactional_fixtures = true

  # Figure out :type attributes from directory names
  config.infer_spec_type_from_file_location!

  # Load the entire application so we get zero-coverage files if we're running
  # the entire suite
  Rails.application.eager_load! unless config.files_to_run.one?
end
