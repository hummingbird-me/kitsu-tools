require 'test_helper'

class FullMangaControllerTest < ActionController::TestCase
  test "can get manga details" do
    get :show, format: :json, id: 'monster'
    assert_response 200
    assert_equal FullMangaSerializer.new(manga(:monster)).to_json, @response.body
  end
end
