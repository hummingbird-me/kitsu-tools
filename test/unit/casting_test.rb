require 'test_helper'

class CastingTest < ActiveSupport::TestCase
  should belong_to(:anime)
  should belong_to(:character)
  should belong_to(:voice_actor)
  should validate_presence_of(:anime)
  should validate_presence_of(:character)
  should_not validate_presence_of(:voice_actor)
end
