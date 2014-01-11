require 'test_helper'

class LibraryEntriesControllerTest < ActionController::TestCase
  test "can get user library entries" do
    get :index, format: :json, user_id: 'vikhyat'
    assert_response 200
    assert JSON.parse(@response.body)["library_entries"].any? {|x| x["anime_id"] == "sword-art-online" }
  end

  test "cannot get private library entries" do
    library_entry = LibraryEntry.where(anime_id: anime(:sword_art_online), user_id: users(:vikhyat)).first
    library_entry.update_attributes private: true
    get :index, format: :json, user_id: 'vikhyat'
    assert_response 200
    assert !JSON.parse(@response.body)["library_entries"].any? {|x| x["anime_id"] == "sword-art-online" }
    sign_in users(:josh)
    get :index, format: :json, user_id: 'vikhyat'
    assert_response 200
    assert !JSON.parse(@response.body)["library_entries"].any? {|x| x["anime_id"] == "sword-art-online" }
  end

  test "can get own private library entries" do
    library_entry = LibraryEntry.where(anime_id: anime(:sword_art_online), user_id: users(:vikhyat)).first
    library_entry.update_attributes private: true
    sign_in users(:vikhyat)
    get :index, format: :json, user_id: 'vikhyat'
    assert_response 200
    assert JSON.parse(@response.body)["library_entries"].any? {|x| x["anime_id"] == "sword-art-online" }
  end

  test "need to be authenticated to create library entry" do
    post :create, library_entry: {anime_id: 'monster', status: 'Plan to Watch'}
    assert_nil LibraryEntry.where(anime_id: anime(:monster), user_id: users(:vikhyat)).first
  end

  test "can create library entry once authenticated" do
    sign_in users(:vikhyat)
    post :create, library_entry: {anime_id: 'monster', status: 'Plan to Watch'}
    assert_response 200
    assert_not_nil LibraryEntry.where(anime_id: anime(:monster), user_id: users(:vikhyat)).first
  end

  test "need to be authenticated as correct user to update library entry" do
    id = watchlists(:one).id
    put :update, id: id, library_entry: {status: 'On Hold', rating: 3.5}
    assert_equal "Plan to Watch", LibraryEntry.find(id).status
    sign_in users(:josh)
    put :update, id: id, library_entry: {status: 'On Hold', rating: 3.5}
    assert_equal "Plan to Watch", LibraryEntry.find(id).status
  end

  test "can update library entry when authenticated" do
    id = watchlists(:one).id
    sign_in users(:vikhyat)
    put :update, id: id, library_entry: {status: 'On Hold', rating: 3.5}
    assert_equal "On Hold", LibraryEntry.find(id).status
    assert_equal 3.5, LibraryEntry.find(id).rating
  end

  test "need to be authenticated as the correct user to destroy library entry" do
    id = watchlists(:one).id
    delete :destroy, id: id
    assert_not_nil LibraryEntry.find_by_id(id)
    sign_in users(:josh)
    delete :destroy, id: id
    assert_not_nil LibraryEntry.find_by_id(id)
  end

  test "can destroy library entry when authenticated" do
    id = watchlists(:one).id
    sign_in users(:vikhyat)
    delete :destroy, id: id
    assert_nil LibraryEntry.find_by_id(id)
  end
end
