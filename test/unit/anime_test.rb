require 'test_helper'

class AnimeTest < ActiveSupport::TestCase
  should have_many(:quotes).dependent(:destroy)
  should have_many(:castings).dependent(:destroy)
  should have_many(:reviews).dependent(:destroy)
  should have_many(:gallery_images).dependent(:destroy)
  should have_many(:watchlists).dependent(:destroy)
  should have_and_belong_to_many(:genres)
  should have_and_belong_to_many(:producers)
  should have_and_belong_to_many(:franchises)
  should validate_presence_of(:title)
  should validate_uniqueness_of(:title)

  test "should implement search scopes" do
    assert Anime.fuzzy_search_by_title("swodr atr onlien").include?(anime(:sword_art_online))
    assert Anime.simple_search_by_title("sword art").include?(anime(:sword_art_online))
  end
end
