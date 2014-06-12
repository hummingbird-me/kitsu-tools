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

  test "need to be signed in to save user" do
    user = users(:vikhyat)
    initial_about = user.about
    put :update, format: :json, id: 'vikhyat', user: {about: "this is a test"}
    assert_equal initial_about, User.find("vikhyat").about
  end

  test "need to be signed in as the correct user to save user" do
    sign_in users(:josh)
    user = users(:vikhyat)
    initial_about = user.about
    put :update, format: :json, id: 'vikhyat', user: {about: "this is a test"}
    assert_equal initial_about, User.find("vikhyat").about
  end

  test "can save user when logged in as the correct user" do
    user = users(:vikhyat)
    sign_in user
    initial_about = user.about
    put :update, format: :json, id: 'vikhyat', user: {about: "this is a test"}
    assert_response 200
    assert_equal "this is a test", User.find("vikhyat").about
  end
end
