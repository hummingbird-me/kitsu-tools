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

  test "slugs work" do
    g = Genre.new
    g.name = "Environmental"
    assert g.save
    assert_equal g.slug, "environmental"
    assert_equal g, Genre.find("environmental")
  end
end
