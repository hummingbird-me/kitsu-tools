require 'test_helper'

class GroupsControllerTest < ActionController::TestCase
  test "can get trending groups" do
    get :index
    assert_response :ok
  end

  test "can get group page" do
    get :show, id: 'gumi-appreciation-group'
    assert_response :ok
    assert_preloaded 'groups'
  end

  test "can get group json" do
    get :show, format: :json, id: 'gumi-appreciation-group'
    assert_response :ok
    assert_equal GroupSerializer.new(groups(:gumi)).to_json, @response.body
  end

  test "can create new group" do
    sign_in users(:josh)
    post :create, group: {name: 'Sugar Water'}
    assert_response :created
  end

  test "cannot create two groups with the same name" do
    sign_in users(:josh)
    post :create, group: {name: 'Sugar Water'}
    post :create, group: {name: 'Sugar Water'}
    assert_response :conflict
  end

  test "can delete a group" do
    sign_in users(:vikhyat)
    delete :destroy, id: 'gumi-appreciation-group'
    assert_response :ok
  end

  test "cannot delete a group if not admin" do
    sign_in users(:josh)
    delete :destroy, id: 'gumi-appreciation-group'
    assert_response 403
  end

  test "can edit a group if admin" do
    sign_in users(:vikhyat)
    put :update, id: 'gumi-appreciation-group', group: {
      bio: 'Mini bio',
      about: 'Longer about section'
    }
    assert_response :ok
  end
end
