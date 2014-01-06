require 'simplecov'
SimpleCov.start 'rails'

ENV["RAILS_ENV"] = "test"

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'sidekiq/testing'
Sidekiq::Testing.inline!

$redis = MockRedis.new

class ActiveSupport::TestCase
  fixtures :all
end

class ActionController::TestCase
  include Devise::TestHelpers

  def assert_preloaded(key)
    assert JSON.parse(assigns["preload"].to_json).keys.include?(key), "#{key} should be preloaded"
  end
end
