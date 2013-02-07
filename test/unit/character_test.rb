require 'test_helper'

class CharacterTest < ActiveSupport::TestCase
  should validate_presence_of(:name)
  should_not validate_presence_of(:description)
end
