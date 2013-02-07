require 'test_helper'

class WatchlistTest < ActiveSupport::TestCase
  should belong_to(:user)
  should belong_to(:anime)

  should validate_uniqueness_of(:user_id).scoped_to(:anime_id)
  
end
