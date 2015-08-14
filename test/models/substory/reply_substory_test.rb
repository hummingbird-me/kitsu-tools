require 'test_helper'

class Substory::ReplySubstoryTest < ActiveSupport::TestCase
  test '.build creates a new story with poster and comment' do
    user = users(:josh)
    story = Story::CommentStory.build(user)

    sub = Substory::ReplySubstory.build(story, user, 'dani pls')
    assert_instance_of Substory::ReplySubstory, sub
    assert_equal story, sub.story
    assert_equal user, sub.user
  end
end
