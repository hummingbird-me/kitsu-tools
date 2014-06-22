require 'test_helper'

class MangaLibraryEntriesControllerTest < ActionController::TestCase

  test "can get user library entries" do
    get :index, format: :json, user_id: 'vikhyat'
    assert_response 200
    assert_not_empty JSON.parse(@response.body)["manga_library_entries"]
  end

  test "cannot get private library entries" do
    manga_library_entries = MangaLibraryEntry.where(manga: manga(:blame), user: users(:vikhyat)).first
    manga_library_entries.private = true
    manga_library_entries.save()
    get :index, format: :json, user_id: 'vikhyat'
    assert_response 200
    assert_empty JSON.parse(@response.body)["manga_library_entries"]
    sign_in users(:josh)
    get :index, format: :json, user_id: 'vikhyat'
    assert_response 200
    assert_empty JSON.parse(@response.body)["manga_library_entries"]
  end

  test "can get own private library entries" do
    manga_library_entries = MangaLibraryEntry.where(manga: manga(:blame), user: users(:vikhyat)).first
    manga_library_entries.private = true
    manga_library_entries.save()
    sign_in users(:vikhyat)
    get :index, format: :json, user_id: 'vikhyat'
    assert_response 200
    assert_not_empty JSON.parse(@response.body)["manga_library_entries"]
  end

  test "need to be authenticated to create library entry" do
    post :create, manga_library_entry: {user_id: users(:vikhyat), manga_id: 'monster', status: 'Plan to Read'}
    assert_nil MangaLibraryEntry.where(manga: manga(:monster), user: users(:vikhyat)).first
  end

  test "can create library entry once authenticated" do
    sign_in users(:vikhyat)
    post :create, manga_library_entry: {user_id: users(:vikhyat), manga_id: 'monster', status: 'Plan to Read', chapters_readed: 8, volumes_readed: 2, private: true}
    assert_response 200
    manga_library_entries = MangaLibraryEntry.where(manga: manga(:monster), user_id: users(:vikhyat)).first
    assert_not_nil manga_library_entries
    assert_equal "Plan to Read", manga_library_entries.status
    assert_equal 8, manga_library_entries.chapters_readed
    assert_equal 2, manga_library_entries.volumes_readed
    assert manga_library_entries.private?
  end

  test "need to be authenticated as correct user to update library entry" do
    id = manga_library_entry(:vikhyatblame).id
    put :update, id: id, manga_library_entry: {status: 'On Hold', rating: 3.5}
    assert_equal "Currently Reading", MangaLibraryEntry.find(id).status
    sign_in users(:josh)
    put :update, id: id, manga_library_entry: {status: 'On Hold', rating: 3.5}
    assert_equal "Currently Reading", MangaLibraryEntry.find(id).status
  end

  test "can update library entry when authenticated" do
    id = manga_library_entry(:joshblame).id
    sign_in users(:josh)
    put :update, id: id, manga_library_entry: {status: 'On Hold', rating: 3.5, chapters_readed: 3}
    assert_equal "On Hold", MangaLibraryEntry.find(id).status
    assert_equal 3.5, MangaLibraryEntry.find(id).rating
    assert_equal 3, MangaLibraryEntry.find(id).chapters_readed
  end

  test "need to be authenticated as the correct user to destroy library entry" do
    id = manga_library_entry(:vikhyatblame).id
    delete :destroy, id: id
    assert_not_nil MangaLibraryEntry.find_by_id(id)
    sign_in users(:josh)
    delete :destroy, id: id
    assert_not_nil MangaLibraryEntry.find_by_id(id)
  end

  test "can destroy library entry when authenticated" do
    id = manga_library_entry(:joshblame).id
    sign_in users(:josh)
    delete :destroy, id: id
    assert_nil MangaLibraryEntry.find_by_id(id)
  end

end
