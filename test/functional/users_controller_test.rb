require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "can get following" do
    get :index, format: :json, followed_by: 'vikhyat'
    assert_response 200
    assert JSON.parse(@response.body)["users"].any? {|x| x["id"] == 'Josh' }
  end

  test "can get followers" do
    get :index, format: :json, followers_of: 'Josh'
    assert_response 200
    assert JSON.parse(@response.body)["users"].any? {|x| x["id"] == 'vikhyat' }
  end
end
