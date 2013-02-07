require 'test_helper'

class GenreTest < ActiveSupport::TestCase
  should have_and_belong_to_many(:animes)
  should validate_presence_of(:name)
  should validate_uniqueness_of(:name)
  should validate_presence_of(:slug)

  test "slugs are generated automatically and can be used to find genres" do
    g = Genre.new
    g.name = "Environmental"
    assert g.save
    assert_equal g.slug, "environmental"
    assert_equal g, Genre.find("environmental")
  end
end
