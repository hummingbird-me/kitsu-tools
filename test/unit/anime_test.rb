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
    anime = FactoryGirl.create(:anime)
    assert_equal Anime.find(anime.slug), anime
  end

  test "should detect sfw status correctly" do
    sfw = FactoryGirl.create(:anime)
    nsfw = FactoryGirl.create(:anime, title: "asdf 2", age_rating: "Rx")
    assert sfw.sfw?
    assert !nsfw.sfw?
  end
end
