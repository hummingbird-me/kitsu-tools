require 'test_helper'

class ReviewTest < ActiveSupport::TestCase
  test "cannot create a review without a user" do
    r = Review.new
    r.anime = anime(:sword_art_online)
    r.content = "test"
    r.positive = true
    assert !r.save
  end

  test "cannot create a review without an anime" do
    r = Review.new
    r.user = users(:x10afreedom)
    r.content = "test"
    r.positive = false
    assert !r.save
  end

  test "cannot create a review without content" do
    r = Review.new
    r.user = users(:rika)
    r.anime = anime(:sword_art_online)
    r.positive = true
    assert !r.save
  end

  test "cannot create a review without specifying positiveness" do
    r = Review.new
    r.user = users(:lpfmaniak)
    r.anime = anime(:sword_art_online)
    r.content = "test"
    assert !r.save
  end
end
