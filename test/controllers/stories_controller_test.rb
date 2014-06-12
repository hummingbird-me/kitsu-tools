require 'test_helper'

class StoriesControllerTest < ActionController::TestCase
  test "can get user feed stories" do
    get :index, format: :json, user_id: 'vikhyat'
    assert_response 200
  end

  test "can create a new comment" do
    sign_in users(:vikhyat)
    post :create, story: {type: "comment", comment: "this is a test comment", user_id: "Josh"}
    assert_response 200
    assert_not_nil users(:josh).stories.first
    assert_equal users(:josh).stories.first.substories.first.data["comment"], "this is a test comment"
  end
end
