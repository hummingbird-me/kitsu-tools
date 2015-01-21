require 'test_helper'

class FavoritesControllerTest < ActionController::TestCase

  test "can get user favorites" do 
    get :index, format: :json, user_id: 'vikhyat', type: 'Anime'
    assert_response :success
  end

  test "can add anime to favorites" do
    sign_in users(:vikhyat)

    assert_difference ->{ Favorite.where(user: users(:vikhyat)).count } do
      post :create, format: :json, favorite: {user_id: 'vikhyat', item_id: 'sword-art-online', item_type: 'Anime'}
    end

    response = JSON.parse(@response.body)['favorite']

    assert_response 200
    assert_equal 'anime', response['item']['type']
    assert_equal 'sword-art-online', response['item']['id']
    assert_equal 9999, response['fav_rank']
  end

  test "can delete anime from favorites" do 
    sign_in users(:vikhyat)

    assert_difference ->{ Favorite.where(user: users(:vikhyat)).count }, -1 do
      post :destroy, format: :json, id: 1
    end
  end

  test "cannot delete anime from other users favorites" do
    sign_in users(:josh)

    assert_no_difference ->{ Favorite.where(user: users(:vikhyat)).count } do
      post :destroy, format: :json, id: 1
    end

    response = JSON.parse(@response.body)
    assert 'Unauthorized', response['error']
  end

  test "can bulk update favorite order" do
    sign_in users(:vikhyat)

    post :update_all, favorites: "[{\"id\":\"1\", \"rank\":\"2\"},{\"id\":\"2\", \"rank\":\"1\"}]"

    assert_equal 2, Favorite.find(1).fav_rank
    assert_equal 1, Favorite.find(2).fav_rank
  end

  test "cannot bulk update other users favorite order" do
    sign_in users(:josh)

    post :update_all, favorites: "[{\"id\":\"1\", \"rank\":\"2\"},{\"id\":\"2\", \"rank\":\"1\"}]"

    assert_equal 1, Favorite.find(1).fav_rank
    assert_equal 2, Favorite.find(2).fav_rank
  end

end
