require 'test_helper'

class Api::V2::AnimeControllerTest < ActionController::TestCase
  test "can get anime" do
    get :show, id: 'sword-art-online'
    assert_response 200
  end
end
