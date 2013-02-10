require 'test_helper'

class EpisodeTest < ActiveSupport::TestCase
  should belong_to(:anime)
  should validate_presence_of(:anime)
  should validate_presence_of(:number)
  should validate_uniqueness_of(:number).scoped_to(:anime_id)
  should_not validate_presence_of(:title)

  test "show the episode number when title is not known" do
    e = Episode.create(anime_id: anime(:sword_art_online).id, number: 22)
    assert_equal e.title, "Episode 22"
  end
end
