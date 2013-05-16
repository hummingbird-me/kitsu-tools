require 'test_helper'

class ReviewTest < ActiveSupport::TestCase
  should belong_to(:user)
  should belong_to(:anime)
  
  should validate_presence_of(:user)
  should validate_presence_of(:anime)
  should validate_presence_of(:content)
end
