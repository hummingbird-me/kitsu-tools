require 'test_helper'

class EpisodeTest < ActiveSupport::TestCase
  should belong_to(:anime)
  should validate_presence_of(:anime)
  should validate_presence_of(:number)
  should validate_uniqueness_of(:number).scoped_to(:anime_id)
  should_not validate_presence_of(:title)

  test "show the episode number when title is not known" do
    episode = FactoryGirl.create(:episode, number: 22, title: nil)
    assert_equal episode.title, "Episode 22"
  end
end
