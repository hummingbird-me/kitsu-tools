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

  test "adult library entries are filtered" do
    anime = Anime.find('sword-art-online')

    get :index, format: :json, user_id: 'vikhyat'
    assert_response 200
    assert JSON.parse(@response.body)["library_entries"].any? {|x| x["anime_id"] == "sword-art-online" }

    anime.age_rating = "R18+"
    anime.save!

    get :index, format: :json, user_id: 'vikhyat'
    assert_response 200
    assert !JSON.parse(@response.body)["library_entries"].any? {|x| x["anime_id"] == "sword-art-online" }

    sign_in users(:josh)
    get :index, format: :json, user_id: 'vikhyat'
    assert_response 200
    assert JSON.parse(@response.body)["library_entries"].any? {|x| x["anime_id"] == "sword-art-online" }
  end

  test "need to be authenticated to create library entry" do
    post :create, library_entry: {anime_id: 'monster', status: 'Plan to Watch'}
    assert_nil LibraryEntry.where(anime_id: anime(:monster), user_id: users(:vikhyat)).first
  end

  test "can create library entry once authenticated" do
    Substory.expects(:from_action)

    sign_in users(:vikhyat)
    post :create, library_entry: {anime_id: 'monster', status: 'Plan to Watch', episodes_watched: 3, private: true}
    assert_response 200
    library_entry = LibraryEntry.where(anime_id: anime(:monster), user_id: users(:vikhyat)).first
    assert_not_nil library_entry
    assert_equal "Plan to Watch", library_entry.status
    assert_equal 3, library_entry.episodes_watched
    assert library_entry.private?
  end

  test "can create library entry with null values set to defaults" do
    sign_in users(:vikhyat)
    post :create, library_entry: {anime_id: 'monster', status: 'Plan to Watch', episodes_watched: nil, private: nil, rewatch_count: nil}
    assert_response 200
    library_entry = LibraryEntry.where(anime_id: anime(:monster), user_id: users(:vikhyat)).first
    assert_not_nil library_entry
    assert_equal "Plan to Watch", library_entry.status
    assert_equal 0, library_entry.episodes_watched
    assert_equal false, library_entry.private
    assert_equal 0, library_entry.rewatch_count
  end

  test "need to be authenticated as correct user to update library entry" do
    id = library_entries(:one).id
    put :update, id: id, library_entry: {status: 'On Hold', rating: 3.5}
    assert_equal "Plan to Watch", LibraryEntry.find(id).status
    sign_in users(:josh)
    put :update, id: id, library_entry: {status: 'On Hold', rating: 3.5}
    assert_equal "Plan to Watch", LibraryEntry.find(id).status
  end

  test "can update library entry when authenticated" do
    Substory.expects(:from_action)
    id = library_entries(:one).id
    sign_in users(:vikhyat)
    put :update, id: id, library_entry: {status: 'On Hold', rating: 3.5, episodes_watched: 3}
    assert_equal "On Hold", LibraryEntry.find(id).status
    assert_equal 3.5, LibraryEntry.find(id).rating
    assert_equal 3, LibraryEntry.find(id).episodes_watched
  end

  test "need to be authenticated as the correct user to destroy library entry" do
    id = library_entries(:one).id
    delete :destroy, id: id
    assert_not_nil LibraryEntry.find_by_id(id)
    sign_in users(:josh)
    delete :destroy, id: id
    assert_not_nil LibraryEntry.find_by_id(id)
  end

  test "can destroy library entry when authenticated" do
    id = library_entries(:one).id
    sign_in users(:vikhyat)
    delete :destroy, id: id
    assert_nil LibraryEntry.find_by_id(id)
  end

  test "updating rating doesn't create story" do
    Substory.expects(:from_action).never
    id = library_entries(:one).id
    sign_in users(:vikhyat)
    put :update, id: id, library_entry: {rating: 2}
  end

  test "create story when episode count is incremented by one" do
    id = library_entries(:one).id
    le = LibraryEntry.find(id)
    sign_in users(:vikhyat)

    Substory.expects(:from_action)
    put :update, id: id, library_entry: {episodes_watched: le.episodes_watched+1}

    Substory.expects(:from_action).never
    put :update, id: id, library_entry: {episodes_watched: le.episodes_watched+5}
  end
end
