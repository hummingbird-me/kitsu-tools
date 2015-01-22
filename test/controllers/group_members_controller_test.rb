require 'test_helper'

class GroupMembersControllerTest < ActionController::TestCase
  test "can get members of a group" do
    sign_in users(:josh)
    get :index, group_id: 'gumi-appreciation-group', page: 1
    assert_response :ok
    assert_includes JSON.parse(@response.body), "group_members"
    assert_equal 1, JSON.parse(@response.body)["group_members"].length

    # admins of the group should see pending users
    sign_in users(:vikhyat)
    get :index, group_id: 'gumi-appreciation-group', page: 1
    assert_response :ok
    assert_includes JSON.parse(@response.body), "group_members"
    assert_equal 2, JSON.parse(@response.body)["group_members"].length
  end

  test "can join a group" do
    group_members(:gumi_pleb).destroy
    sign_in users(:josh)
    post :create, group_member: {
      group_id: groups(:gumi).id,
      user_id: users(:josh).id
    }
    assert_response :created
  end

  test "pleb ranked users can leave a group freely" do
    pleb = group_members(:gumi_pleb)
    sign_in pleb.user
    delete :destroy, id: pleb.id
    assert_response :ok
  end

  test "mod ranked users can leave a group freely" do
    mod = group_members(:jerks_moderator)
    sign_in mod.user
    delete :destroy, id: mod.id
    assert_response :ok
  end

  test "mods and admins can boot lower-ranking members from the group" do
    sign_in group_members(:gumi_admin).user
    pleb = group_members(:gumi_pleb)
    delete :destroy, id: pleb.id
    assert_response :ok
  end

  test "admins can promote a user to admin" do
    sign_in group_members(:gumi_admin).user
    membership = group_members(:gumi_pleb)
    put :update, id: membership.id, group_member: {
      rank: 'admin'
    }
    assert_response :ok
  end

  test "last admin cannot resign" do
    sign_in group_members(:gumi_admin).user
    admin = group_members(:gumi_admin)
    delete :destroy, id: admin.id
    assert_response 400
  end
end
