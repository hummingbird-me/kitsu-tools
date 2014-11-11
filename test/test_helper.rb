require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

ENV["RAILS_ENV"] = "test"

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'sidekiq/testing'
Sidekiq::Testing.inline!

require 'mocha/mini_test'

$redis = ConnectionPool.new { MockRedis.new }

class ActiveSupport::TestCase
  fixtures :all
end

class ActionController::TestCase
  include Devise::TestHelpers
  include Devise::Controllers::SignInOut

  def assert_preloaded(key)
    assert JSON.parse(assigns["preload"].to_json).map {|x| x.keys }.flatten.include?(key), "#{key} should be preloaded"
  end
end

# Don't want SSL redirects in the test suite
module ActionController::ForceSSL::ClassMethods
  def force_ssl(options={}); end
end
