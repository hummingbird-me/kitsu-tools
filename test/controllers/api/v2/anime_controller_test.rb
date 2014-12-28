require 'test_helper'

class Api::V2::AnimeControllerTest < ActionController::TestCase
  setup do
    @controller.class.skip_before_filter :require_client_id
  end

  test "can get anime" do
    get :show, id: anime(:sword_art_online).id
    assert_response 200
  end

  test "can multi-get anime" do
    get :show, id: [anime(:sword_art_online).id, anime(:monster).id].join(',')
    assert_response 200
    assert JSON.parse(@response.body)["anime"].is_a? Array
    assert_equal 2, JSON.parse(@response.body)["anime"].length
  end
end
