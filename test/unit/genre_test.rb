require 'test_helper'

class GenreTest < ActiveSupport::TestCase
  test "cannot create genre without name" do
    g = Genre.new
    g.name = ""
    assert !g.save
  end

  test "name must be unique" do
    g = Genre.new
    g.name = "Fantasy"
    assert !g.save
  end
end
