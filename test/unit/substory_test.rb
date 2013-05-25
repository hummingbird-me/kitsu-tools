require 'test_helper'

class SubstoryTest < ActiveSupport::TestCase
  should belong_to(:user)
  should belong_to(:story)
  should belong_to(:target)
  should validate_presence_of(:substory_type)
  should validate_presence_of(:user)
  should validate_presence_of(:story)
  should validate_presence_of(:target)
end
