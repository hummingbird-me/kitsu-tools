require 'test_helper'

class WatchlistTest < ActiveSupport::TestCase
  test "cannot create duplicates" do
    w = Watchlist.new
    w.user = users(:vikhyat)
    w.anime = anime(:sword_art_online)
    assert w.save
    w = Watchlist.new
    w.user = users(:vikhyat)
    w.anime = anime(:sword_art_online)
    assert !w.save
  end
end
