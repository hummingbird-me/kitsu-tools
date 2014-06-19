require 'test_helper'

class MangaLibrariesControllerTest < ActionController::TestCase

  test "can get user library entries" do
    get :index, format: :json, user_id: 'vikhyat'
    assert_response 200
    assert JSON.parse(@response.body)["manga_libraries"].any? { |x| x["item_type"] == "Manga" }
  end

  test "cannot get private library entries" do
    manga_library = Consuming.where(item: manga(:fruta), user: users(:vikhyat)).first
    manga_library.private = true
    manga_library.save()
    get :index, format: :json, user_id: 'vikhyat'
    assert_response 200
    assert !JSON.parse(@response.body)["manga_libraries"].any? {|x| x["item_slug"] == "fruta" }
    sign_in users(:josh)
    get :index, format: :json, user_id: 'vikhyat'
    assert_response 200
    assert !JSON.parse(@response.body)["manga_libraries"].any? {|x| x["item_slug"] == "fruta" }
  end

  test "can get own private library entries" do
    manga_library = Consuming.where(item: manga(:fruta), user: users(:vikhyat)).first
    manga_library.private = true
    manga_library.save()
    sign_in users(:vikhyat)
    get :index, format: :json, user_id: 'vikhyat'
    assert_response 200
    assert JSON.parse(@response.body)["manga_libraries"].any? {|x| x["item_slug"] == "fruta" }
  end

  test "need to be authenticated to create library entry" do
    post :create, manga_libraries: {user_id: users(:vikhyat), item_id: 'monster', item_type: 'Manga', status: 'Plan to Watch'}
    assert_nil Consuming.where(item: manga(:monster), user: users(:vikhyat)).first
  end

  test "can create library entry once authenticated" do
    sign_in users(:vikhyat)
    post :create, manga_libraries: {user_id: users(:vikhyat), item_id: 'monster', item_type: 'Manga', status: 'Plan to Watch', parts_consumed: 2, private: true}
    assert_response 200
    manga_library = Consuming.where(item: manga(:monster), user_id: users(:vikhyat)).first
    assert_not_nil manga_library
    assert_equal "Plan to Watch", manga_library.status
    assert_equal 2, manga_library.parts_consumed
    assert manga_library.private?
  end

  test "need to be authenticated as correct user to update library entry" do
    id = consumings(:two).id
    put :update, id: id, manga_libraries: {status: 'On Hold', rating: 3.5}
    assert_equal "Currently Watching", Consuming.find(id).status
    sign_in users(:josh)
    put :update, id: id, manga_libraries: {status: 'On Hold', rating: 3.5}
    assert_equal "Currently Watching", Consuming.find(id).status
  end

  test "can update library entry when authenticated" do
    id = consumings(:one).id
    sign_in users(:josh)
    put :update, id: id, manga_libraries: {status: 'On Hold', rating: 3.5, parts_consumed: 3}
    assert_equal "On Hold", Consuming.find(id).status
    assert_equal 3.5, Consuming.find(id).rating
    assert_equal 3, Consuming.find(id).parts_consumed
  end

  test "need to be authenticated as the correct user to destroy library entry" do
    id = consumings(:two).id
    delete :destroy, id: id
    assert_not_nil Consuming.find_by_id(id)
    sign_in users(:josh)
    delete :destroy, id: id
    assert_not_nil Consuming.find_by_id(id)
  end

  test "can destroy library entry when authenticated" do
    id = consumings(:one).id
    sign_in users(:josh)
    delete :destroy, id: id
    assert_nil Consuming.find_by_id(id)
  end

end
