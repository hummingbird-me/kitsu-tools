require 'test_helper'

class Api::V2::MangaControllerTest < ActionController::TestCase
  test "can get manga json" do
    get :show, id: 'monster'
    assert_response 200
    assert_equal MangaSerializer.new(manga(:monster)).to_json, @response.body
  end
end
