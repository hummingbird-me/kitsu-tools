require 'test_helper'

class FollowTest < ActiveSupport::TestCase
  test "follower and following counts" do
    u1 = FactoryGirl.create(:user)
    u2 = FactoryGirl.create(:user)
    
    # Counts should be zero initially.
    assert_equal u1.followers_count, 0
    assert_equal u2.followers_count, 0
    assert_equal u1.following_count, 0
    assert_equal u2.following_count, 0
  end
end
