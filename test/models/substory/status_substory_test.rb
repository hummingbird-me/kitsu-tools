require 'test_helper'

class Substory::StatusSubstoryTest < ActiveSupport::TestCase
  test "build creates a new instance within a story" do
    user = users(:josh)
    anime = anime(:monster)

    story = Story::LibraryStory.for_user_and_anime(user, anime)
    substory = Substory::StatusSubstory.build(story, 'old', 'new')

    assert_instance_of Story::StatusSubstory, substory
    assert_equal story, substory.story
    assert_equal user, substory.user
  end
end

