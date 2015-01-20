require 'test_helper'

class StoriesControllerTest < ActionController::TestCase
  test "can get user feed stories" do
    get :index, format: :json, user_id: 'vikhyat'
    assert_response 200
  end

  test "can get group feed stories" do
    get :index, format: :json, group_id: 'jerks'
    assert_response 200
  end

  test "can create new comment stories" do
    sign_in users(:vikhyat)
    post :create, format: :json, story: {user_id: 'vikhyat', comment: 'test!', adult: false}
    response = JSON.parse(@response.body)["story"]

    assert_response 200
    assert_equal 'comment', response["type"]
    assert_equal 'test!', response["comment"]
  end

  test "can delete user feed stories" do
    sign_in users(:vikhyat)

    story = Action.broadcast(
      action_type: "created_profile_comment",
      user: users(:vikhyat),
      poster: users(:vikhyat),
      comment: "Test"
    )

    substory = story.substories.first

    delete :destroy, id: story.id
    assert_nil Story.find_by(id: story.id)
    assert_nil Substory.find_by(id: substory.id)
  end

  test "cannot delete stories if not authorized" do
    sign_in users(:vikhyat)

    story = Action.broadcast(
      action_type: "created_profile_comment",
      user: users(:josh),
      poster: users(:josh),
      comment: "Test"
    )

    delete :destroy, id: story.id
    assert_not_nil Story.find_by(id: story.id)
  end

  test "can like stories" do
    sign_in users(:vikhyat)

    story = Action.broadcast(
      action_type: "created_profile_comment",
      user: users(:vikhyat),
      poster: users(:vikhyat),
      comment: "Test",
      adult: false
    )

    assert_equal 0, story.reload.total_votes
    put :update, id: story.id, story: {is_liked: true}
    assert_equal 1, story.reload.total_votes
    put :update, id: story.id, story: {is_liked: false}
    assert_equal 0, story.reload.total_votes
  end
end
