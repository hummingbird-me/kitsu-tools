require 'test_helper'

class VersionsControllerTest < ActionController::TestCase
  setup do
    sign_in users(:josh)
  end

  test "can get versions" do
    get :index, format: :json
    assert_response 200

    data = JSON.parse(@response.body)
    assert_not_empty data["versions"]
    assert_equal 1, data["versions"].count
    assert_equal "pending", data["versions"][0]["state"]
  end

  test "can get pending versions" do
    get :index, format: :json, state: 'pending'
    assert_response 200

    data = JSON.parse(@response.body)
    assert_not_empty data["versions"]
    assert_equal 1, data["versions"].count
    assert_equal "pending", data["versions"][0]["state"]
  end

  test "can get history versions" do
    get :index, format: :json, state: 'history'
    assert_response 200

    data = JSON.parse(@response.body)
    assert_not_empty data["versions"]
    assert_equal 2, data["versions"].count
    assert_equal "history", data["versions"][0]["state"]
    assert_equal "history", data["versions"][1]["state"]
  end

  test "can approve a version" do
    old_version = versions(:one)
    assert_equal 1, old_version["state"] # pending
    assert_equal 0, User.find(users(:josh).id).approved_edit_count

    put :update, format: :json, id: old_version.id
    assert_response 200

    version = Version.first
    assert_equal "history", version.state
    assert_equal old_version.object["synopsis"], anime(:sword_art_online)["synopsis"]

    assert_equal 1, User.find(users(:josh).id).approved_edit_count
  end

  test "can reject a version" do
    assert_equal 3, Version.count
    assert_equal 0, User.find(users(:josh).id).rejected_edit_count
    delete :destroy, format: :json, id: versions(:one).id
    assert_response 200
    assert_equal 2, Version.count
    assert_equal 1, User.find(users(:josh).id).rejected_edit_count
  end

  test "hidden endpoint if not staff" do
    sign_in users(:vikhyat)
    assert_raise ActionController::RoutingError do
      get :index, format: :json
      get :show, format: :json, id: versions(:one).id
      put :update, format: :json, id: versions(:one).id
      delete :destroy, format: :json, id: versions(:one).id
    end
  end
end
