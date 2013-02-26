require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should validate_presence_of(:name)
  should validate_uniqueness_of(:name)
  should validate_presence_of(:email)
  should validate_uniqueness_of(:email)
  should validate_uniqueness_of(:facebook_id)
  should have_many(:watchlists)
  should have_many(:reviews)
  should have_many(:quotes)
  
  test "top_genres" do
    g1 = FactoryGirl.create(:genre)
    g2 = FactoryGirl.create(:genre, name: "Adventure")
    a1 = FactoryGirl.create(:anime, genres: [g1, g2])
    a2 = FactoryGirl.create(:anime, title: "adsf 2", genres: [g1])
    u = FactoryGirl.create(:user)
    Watchlist.create(anime: a1, user: u, status: "Currently Watching")
    Watchlist.create(anime: a2, user: u, status: "Currently Watching")
    assert_operator u.top_genres[g1], :>, u.top_genres[g2]
    assert_equal u.top_genres.keys[0], g1
  end
  
  test "episodes_viewed" do
    a1 = FactoryGirl.create(:anime)
    a2 = FactoryGirl.create(:anime, title: "adsf 2")
    u  = FactoryGirl.create(:user)
    e1 = FactoryGirl.create(:episode, anime: a1)
    e2 = FactoryGirl.create(:episode, anime: a1, number: 2)
    e3 = FactoryGirl.create(:episode, anime: a2)
    
    assert_equal u.episodes_viewed(a1).count, 0
    assert_equal u.episodes_viewed(a2).count, 0
    
    EpisodeView.create(user: u, anime: a1, episode: e1)
    assert_equal u.episodes_viewed(a1).count, 1
    assert_equal u.episodes_viewed(a2).count, 0

    EpisodeView.create(user: u, anime: a1, episode: e2)
    assert_equal u.episodes_viewed(a1).count, 2
    assert_equal u.episodes_viewed(a2).count, 0

    EpisodeView.create(user: u, anime: a2, episode: e3)
    assert_equal u.episodes_viewed(a1).count, 2
    assert_equal u.episodes_viewed(a2).count, 1
  end
end
