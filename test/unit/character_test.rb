require 'test_helper'

class CharacterTest < ActiveSupport::TestCase
  test "cannot create a character without a name" do
    c = Character.new
    c.name = ""
    c.description = "TBD"
    assert !c.save
  end

  test "can create a character without a description" do
    c = Character.new
    c.name = "kirito"
    assert c.save
  end
end
