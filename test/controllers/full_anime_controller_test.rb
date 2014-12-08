require 'test_helper'

class FullAnimeControllerTest < ActionController::TestCase
  test "can get anime details" do
    get :show, format: :json, id: 'sword-art-online'
    assert_response 200
    assert_equal FullAnimeSerializer.new(anime(:sword_art_online)).to_json, @response.body
  end

  test "can edit an anime as staff" do
    sign_in users(:josh)

    data = {
      synopsis: "Hello, World!",
      episode_count: 32,
      edit_comment: "Goodbye, World!"
    }

    put :update, format: :json, id: 'sword-art-online', full_anime: data
    assert_response 200
    assert_equal 4, Version.count # 3 fixtures + new

    assert_equal "history", Version.last.state
    assert_equal data[:edit_comment], Version.last.comment

    anime = anime(:sword_art_online)
    assert_equal data[:synopsis], anime.synopsis
    assert_equal data[:episode_count], anime.episode_count
  end

  test "can edit an anime" do
    sign_in users(:vikhyat)

    data = {
      synopsis: "Hello, World!",
      episode_count: 32,
      edit_comment: "Goodbye, World!"
    }

    put :update, format: :json, id: 'sword-art-online', full_anime: data
    assert_response 200
    assert_equal 4, Version.count # 3 fixtures + new

    version = Version.last
    assert_equal "pending", version.state
    assert_equal data[:synopsis], version.object['synopsis']
    assert_equal data[:episode_count], version.object['episode_count']
    assert_equal data[:edit_comment], version.comment
  end
end
