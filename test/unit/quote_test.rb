require 'test_helper'

class QuoteTest < ActiveSupport::TestCase
  test "cannot create a quote without content" do
    q = Quote.new
    q.content = ""
    q.anime = animes(:sword_art_online)
    q.character = characters(:kirito)
    assert !q.save
  end

  test "can create a quote without a character" do
    q = Quote.new
    q.content = "test"
    q.anime = animes(:sword_art_online)
    assert q.save
  end

  test "cannot create a quote without an anime" do
    q = Quote.new
    q.content = "test"
    q.character = characters(:kirito)
    assert !q.save
  end
end
