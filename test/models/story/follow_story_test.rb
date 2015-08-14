require 'test_helper'

class Story::FollowStoryTest < ActiveSupport::TestCase
  test "for_user creates new story if there's none yet" do
    user = users(:josh)

    story = Story::FollowStory.for_user(user)
    assert_instance_of Story::FollowStory, story
  end

  test "for_user reuses story if there's already one" do
    user = users(:josh)

    first = Story::FollowStory.create(user: user)
    second = Story::FollowStory.for_user(user)

    assert_instance_of Story::FollowStory, second
    assert_equal first, second
  end

  test "for_user returns new story if the existing story is old" do
    user = users(:josh)

    first = Story::FollowStory.create(user: user, created_at: 12.hours.ago)
    second = Story::FollowStory.for_user(user)

    assert_instance_of Story::FollowStory, second
    refute_equal first, second
  end
end

