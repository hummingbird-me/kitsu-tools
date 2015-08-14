require 'test_helper'

class Substory::CommentSubstoryTest < ActiveSupport::TestCase
  test "build creates a new instance within a story" do
    user = users(:josh)

    story = Story::CommentStory.build(user)
    sub = Substory::CommentSubstory.build(story, user, 'O-oniichan, be gentle')

    assert_instance_of Story::CommentSubstory, sub
    assert_equal story, sub.story
    assert_equal user, sub.user
  end
end
