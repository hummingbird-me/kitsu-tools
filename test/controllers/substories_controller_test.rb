require 'test_helper'

class SubstoriesControllerTest < ActionController::TestCase
  test "can get substories for a story" do
    story = Action.broadcast(
      action_type: "created_profile_comment",
      user: users(:vikhyat),
      poster: users(:vikhyat),
      comment: "Test"
    )

    get :index, format: :json, story_id: story.id
    assert_response 200
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

    delete :destroy, id: substory.id
    assert_nil Substory.find_by(id: story.id)
  end
end
