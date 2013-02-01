require 'test_helper'

class AnimeTest < ActiveSupport::TestCase
  test "can find animes using their slugs" do
    Anime.all.each {|x| x.save }
    assert_equal Anime.find("sword-art-online"), animes(:sword_art_online)
  end

  test "cannot create anime without unique title" do
    a = Anime.new
    a.title = ""
    a.slug = "abc"
    assert !a.save
    a.title = "Sword Art Online"
    assert !a.save
  end

  test "slug is generated automatically" do
    a = Anime.new
    a.title = "Generic Anime"
    assert a.save
    assert_not_nil a.slug
    assert a.slug.length > 0
  end

  test "can get cover image url" do
    assert_not_nil Anime.find("sword-art-online").cover_image_url
  end
end
