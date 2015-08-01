ENV['RAILS_ENV'] = 'test'

require 'codeclimate-test-reporter'
require 'coverage_helper' # Need to be called before Rails
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/rails'
require 'webmock_helper'
require 'mocha/mini_test'

require_dependency 'auth/current_user_provider'

require 'sidekiq/testing'
Sidekiq::Testing.inline!

require 'json_expressions/minitest'
JsonExpressions::Matcher.assume_strict_arrays = false
JsonExpressions::Matcher.assume_strict_hashes = false

require 'webmock/minitest'
WebMock.disable_net_connect!(allow: %w(codeclimate.com robohash.org))
$redis = ConnectionPool.new { MockRedis.new }

module ActiveSupport
  class TestCase
    include FactoryGirl::Syntax::Methods

    fixtures :all
  end
end

module ActionController
  class TestCase
    include Devise::TestHelpers

    def sign_in(user)
      @controller.env['_CURRENT_USER'] = user
    end

    def assert_preloaded(key)
      json = JSON.parse(assigns['preload'].to_json)
             .map(&:keys)
             .flatten
             .include?(key)
      assert json, "#{key} should be preloaded"
    end

    def assert_json_body(matcher)
      assert_json_match(matcher, @response.body)
    end
  end
end
