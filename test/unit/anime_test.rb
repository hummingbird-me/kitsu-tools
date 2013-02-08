require 'test_helper'

class AnimeTest < ActiveSupport::TestCase
  should have_many(:quotes)
  should have_many(:reviews)
  should have_many(:recommendations)
  should validate_presence_of(:title)
  should validate_uniqueness_of(:title)
  should validate_presence_of(:slug)
  should have_and_belong_to_many(:genres)
  should have_and_belong_to_many(:producers)
  
  test "should find anime using slug" do
    assert_not_nil Anime.find("sword-art-online")
  end
end
