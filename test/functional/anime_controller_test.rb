require 'test_helper'

class AnimeControllerTest < ActionController::TestCase
  test "can get anime" do
    get :show, id: 'sword-art-online'
    assert_response 200
    assert assigns["preload"].length > 0
    assert_not_nil assigns["anime"]
  end

  test "redirects to canonical URL" do
    get :show, id: 6589
    assert_response 301
  end

  test "can get upcoming" do
    get :upcoming
    assert_response 200

    get :upcoming, season: :tba
    assert_response 200

    Timecop.freeze( Time.new(2013, 12, 26) ) do
      get :upcoming
      assert_response 200
    end

    Timecop.freeze( Time.new(2012, 4, 8) ) do
      get :upcoming
      assert_response 200
      assert !assigns(:anime).values.flatten.include?(anime(:sword_art_online))

      get :upcoming, season: :summer
      assert_response 200
      assert assigns(:anime).values.flatten.include?(anime(:sword_art_online))
    end
  end

  test "can get index" do
    get :index
    assert_response 200
    assert_not_nil assigns(:filter_years)
    assert_not_nil assigns(:trending_anime)
    assert_not_nil assigns(:trending_reviews)
    assert_not_nil assigns(:recent_reviews)
  end
end
