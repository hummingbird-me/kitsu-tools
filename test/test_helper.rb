require 'rubygems'
require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] = "test"
  require File.expand_path('../../config/environment', __FILE__)
  require 'rails/test_help'
  class ActiveSupport::TestCase
    fixtures :all
  end
end

Spork.each_run do
end
