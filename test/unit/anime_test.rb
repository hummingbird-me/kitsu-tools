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
    nsfw = FactoryGirl.create(:anime, title: "asdf 2", age_rating: "R18+")
    assert sfw.sfw?
    assert !nsfw.sfw?
  end

  test "should filter genres correctly" do
    genre1 = FactoryGirl.create(:genre, name: "fas")
    genre2 = FactoryGirl.create(:genre, name: "asf")
    anime1 = FactoryGirl.create(:anime, genres: [genre1])
    anime2 = FactoryGirl.create(:anime, title: "asdf 2", genres: [genre2])
    
    assert Anime.exclude_genres([genre1, genre2]).length == 0
    assert Anime.exclude_genres([genre2]).include? anime1
    assert Anime.exclude_genres([genre1]).include? anime2
  end
end
