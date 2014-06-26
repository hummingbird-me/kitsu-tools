require 'test_helper'

class StoriesControllerTest < ActionController::TestCase
  test "can get user feed stories" do
    get :index, format: :json, user_id: 'vikhyat'
    assert_response 200
  end

  test "can delete user feed stories" do
    sign_in users(:vikhyat)

    story = Action.broadcast(
      action_type: "created_profile_comment",
      user: users(:vikhyat),
      poster: users(:vikhyat),
      comment: "Test"
    )

    delete :destroy, id: story.id
    assert_nil Story.find_by(id: story.id)
  end

  test "cannot delete stories if not authorized" do
    sign_in users(:josh)

    story = Action.broadcast(
      action_type: "created_profile_comment",
      user: users(:vikhyat),
      poster: users(:vikhyat),
      comment: "Test"
    )

    delete :destroy, id: story.id
    assert_not_nil Story.find_by(id: story.id)
  end

  test "can destroy substories" do
    sign_in users(:vikhyat)

    story = Action.broadcast(
      action_type: "created_profile_comment",
      user: users(:vikhyat),
      poster: users(:vikhyat),
      comment: "Test"
    )
    substory = story.substories.first

    delete :destroy_substory, id: substory.id
    assert_nil Substory.find_by(id: story.id)
  end
end
