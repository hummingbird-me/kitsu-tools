require 'test_helper'

class CharacterTest < ActiveSupport::TestCase
  test "cannot create a character without a name" do
    c = Character.new
    c.name = ""
    c.voice_actor = people(:kirito)
    c.description = "TBD"
    assert !c.save
  end

  test "can create a character without a voice actor" do
    c = Character.new
    c.name = "kirito"
    c.description = "TBD"
    assert c.save
  end

  test "can create a character without a description" do
    c = Character.new
    c.name = "kirito"
    c.voice_actor = people(:kirito)
    assert c.save
  end
end
