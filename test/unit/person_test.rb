require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  should validate_presence_of(:name)
end
