require 'test_helper'

class MangaControllerTest < ActionController::TestCase
  test "can get manga" do
    get :show, id: 'monster'
    assert_response 200
    assert assigns["preload"].length > 0
  end
end
