require 'test_helper'

class MangaControllerTest < ActionController::TestCase
  test "can get manga" do
    get :show, id: 'monster'
    assert_response 200
    assert_preloaded "manga"
  end

  test "can get manga json" do
    get :show, format: :json, id: 'monster'
    assert_response 200
    assert_equal MangaSerializer.new(manga(:monster)).to_json, @response.body
  end
end
