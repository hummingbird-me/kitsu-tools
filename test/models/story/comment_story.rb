require 'test_helper'

class Story::CommentStoryTest < ActiveSupport::TestCase
  test '.build_for_group' do
    user = users(:josh)
    group = Group.new_with_admin({name: 'Sugar Water'}, user)

    story = Story::CommentStory.build_for_group(user, group)
    assert_instance_of Story::CommentStory, story
  end

  test '.build_for_user' do
    user = users(:josh)
    target = users(:vikhyat)

    story = Story::CommentStory.build_for_user(user, target)
    assert_instance_of Story::CommentStory, story
  end

  test '#build_comment and #create_comment' do
    user = users(:josh)

    story = Story::CommentStory.create(user: user)
    substory = story.create_comment(user, 'First!')
    assert_instance_of Substory::CommentSubstory, substory
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
