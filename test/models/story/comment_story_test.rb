require 'test_helper'

class Story::CommentStoryTest < ActiveSupport::TestCase
  test '.build_for_group creates new story with poster and group' do
    user = users(:josh)
    group = Group.new_with_admin({name: 'Sugar Water'}, user)

    story = Story::CommentStory.build_for_group(user, group)
    assert_instance_of Story::CommentStory, story
    assert_equal user.id, story.user_id
    assert_equal group.id, story.group_id
  end

  test ".build_for_user creates a post on another user's profile" do
    user = users(:josh)
    target = users(:vikhyat)

    story = Story::CommentStory.build_for_user(user, target)
    assert_instance_of Story::CommentStory, story
    assert_equal user.id, story.user_id
    assert_equal target.id, story.target_id
  end

  test 'should notify users when we post on their profile' do
    user = users(:josh)
    target = users(:vikhyat)

    assert_difference ->{ Notification.count } do
      story = Story::CommentStory.build_for_user(user, target)
      story.save!
    end
  end
end
