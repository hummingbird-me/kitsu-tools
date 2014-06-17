require 'test_helper'

class Api::V2::AnimeControllerTest < ActionController::TestCase
  test "can get anime" do
    get :show, id: 'sword-art-online'
    assert_response 200

    get :show, id: anime(:sword_art_online).id
    assert_response 200
  end
end
