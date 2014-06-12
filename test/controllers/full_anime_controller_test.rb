require 'test_helper'

class FullAnimeControllerTest < ActionController::TestCase
  test "can get anime details" do
    get :show, format: :json, id: 'sword-art-online'
    assert_response 200
    assert_equal FullAnimeSerializer.new(anime(:sword_art_online)).to_json, @response.body
  end
end
