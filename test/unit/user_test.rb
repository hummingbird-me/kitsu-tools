require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should validate_presence_of(:name)
  should validate_uniqueness_of(:name)
  should validate_presence_of(:email)
  should validate_uniqueness_of(:email)
  should validate_uniqueness_of(:facebook_id)
  should have_many(:watchlists)
  
  test "top_genres" do
    g1 = FactoryGirl.create(:genre)
    g2 = FactoryGirl.create(:genre, name: "Adventure")
    a1 = FactoryGirl.create(:anime, genres: [g1, g2])
    a2 = FactoryGirl.create(:anime, title: "adsf 2", genres: [g1])
    u = FactoryGirl.create(:user)
    Watchlist.create(anime: a1, user: u)
    Watchlist.create(anime: a2, user: u)
    assert_operator u.top_genres[g1], :>, u.top_genres[g2]
    assert_equal u.top_genres.keys[0], g1
  end
end
