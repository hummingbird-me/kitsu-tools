require 'test_helper'

class QuoteTest < ActiveSupport::TestCase
  should belong_to(:anime)
  should belong_to(:user)
  should validate_presence_of(:content)
  should validate_presence_of(:anime)
  should validate_presence_of(:user)
  should_not validate_presence_of(:character_name)
end
