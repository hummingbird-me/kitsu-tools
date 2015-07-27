ENV['RAILS_ENV'] = 'test'

require 'codeclimate-test-reporter'
require 'simplecov'

class SimpleCov::Formatter::MergedFormatter
  def format(result)
    SimpleCov::Formatter::HTMLFormatter.new.format(result)
    CodeClimate::TestReporter::Formatter.new.format(result)
 end
end

if ENV['CODECLIMATE_REPO_TOKEN']
  CodeClimate::TestReporter.start
  SimpleCov.formatter = SimpleCov::Formatter::MergedFormatter
else
  SimpleCov.start do
    add_filter '/test/'
    add_filter '/config/'
    add_filter '/vendor/'

    add_group 'Controllers', 'app/controllers'
    add_group 'Models', 'app/models'
    add_group 'Services', 'app/services'
    add_group 'Serializers', 'app/serializers'
    add_group 'Libs', 'lib/'
  end
  SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter
end

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
