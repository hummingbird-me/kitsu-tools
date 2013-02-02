require 'test_helper'

class QuoteTest < ActiveSupport::TestCase
  test "cannot create a quote without content" do
    q = Quote.new
    q.content = ""
    q.anime = anime(:sword_art_online)
    q.character_name = "kirito"
    q.creator = users(:vikhyat)
    assert !q.save
  end

  test "can create a quote without a character" do
    q = Quote.new
    q.content = "test"
    q.anime = anime(:sword_art_online)
    q.creator = users(:vikhyat)
    assert q.save
  end

  test "cannot create a quote without an anime" do
    q = Quote.new
    q.content = "test"
    q.character_name = "kirito"
    q.creator = users(:vikhyat)
    assert !q.save
  end

  test "cannot create a quote without a creator" do
    q = Quote.new
    q.content = "test"
    q.anime = anime(:sword_art_online)
    assert !q.save
  end

  test "quotes are not marked as visible initially" do
    q = Quote.new
    q.content = "test"
    q.anime = anime(:sword_art_online)
    q.creator = users(:vikhyat)
    assert q.save
    assert !q.visible?
  end
end
