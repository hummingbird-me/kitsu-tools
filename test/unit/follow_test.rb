require 'test_helper'

class FollowTest < ActiveSupport::TestCase
  test "follower and following counts" do
    u1 = FactoryGirl.create(:user)
    u2 = FactoryGirl.create(:user)
    
    assert_equal 0, u1.followers_count
    assert_equal 0, u2.followers_count
    assert_equal 0, u1.following_count
    assert_equal 0, u2.following_count

    u1.followers.push u2; u1.reload; u2.reload
    assert_equal 1, u1.followers_count
    assert_equal 1, u2.following_count
    assert_equal 0, u1.following_count
    assert_equal 0, u2.followers_count

    u2.followers.push u1; u1.reload; u2.reload
    assert_equal 1, u1.followers_count
    assert_equal 1, u2.following_count
    assert_equal 1, u1.following_count
    assert_equal 1, u2.followers_count
    
    u1.followers.delete u2; u1.reload; u2.reload
    assert_equal 0, u1.followers_count
    assert_equal 0, u2.following_count
    assert_equal 1, u1.following_count
    assert_equal 1, u2.followers_count
    
    u1.following.delete u1; u1.reload; u2.reload
    assert_equal 0, u1.followers_count
    assert_equal 0, u2.following_count
    assert_equal 0, u1.following_count
    assert_equal 0, u2.followers_count
  end
end
