require 'test_helper'

class CastingTest < ActiveSupport::TestCase
  test "cannot create casting without anime" do
    c = Casting.new
    c.character = characters(:kirito)
    c.voice_actor = people(:asuna)
    assert !c.save
  end

  test "cannot create casting without character" do
    c = Casting.new
    c.anime = animes(:sword_art_online)
    c.voice_actor = people(:asuna)
    assert !c.save
  end

  test "can create casting without voice actor" do
    c = Casting.new
    c.anime = animes(:sword_art_online)
    c.character = characters(:kirito)
    c.voice_actor = people(:asuna)
    assert c.save
  end
end
