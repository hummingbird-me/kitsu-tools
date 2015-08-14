require 'test_helper'

class Substory::FollowSubstoryTest < ActiveSupport::TestCase
  test '.build creates a new substory for a story' do
    follower = users(:josh)
    following = users(:vikhyat)
    story = Story::FollowStory.for_user(follower)

    substory = Substory::FollowSubstory.build(story, follower, following)

    assert_instance_of Substory::FollowSubstory, substory
    assert_equal follower, substory.user
    assert_equal following, substory.target
  end
end
