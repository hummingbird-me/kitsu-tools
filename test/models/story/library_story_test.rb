require 'test_helper'

class Story::LibraryStoryTest < ActiveSupport::TestCase
  test "for_user_and_anime creates new story if there's none yet" do
    user = users(:josh)
    anime = anime(:monster)

    story = Story::LibraryStory.for_user_and_anime(user, anime)
    assert_instance_of Story::LibraryStory, story
  end

  test "for_user_and_anime reuses story if there's already one" do
    user = users(:josh)
    anime = anime(:monster)

    first = Story::LibraryStory.create(user: user, target: anime)
    second = Story::LibraryStory.for_user_and_anime(user, anime)

    assert_instance_of Story::LibraryStory, second
    assert_equal first, second
  end
end

