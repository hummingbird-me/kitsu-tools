require 'test_helper'

class StoriesControllerTest < ActionController::TestCase
  test "can get user feed stories" do
    get :index, format: :json, user_id: 'vikhyat'
    assert_response 200
  end
end
