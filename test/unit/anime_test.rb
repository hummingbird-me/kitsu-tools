require 'test_helper'

class AnimeTest < ActiveSupport::TestCase
  test "can find animes using their slugs" do
    Anime.all.each {|x| x.save }
    assert_equal Anime.find("sword-art-online"), animes(:sword_art_online)
  end
end
