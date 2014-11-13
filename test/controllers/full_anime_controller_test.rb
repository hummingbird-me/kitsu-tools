require 'test_helper'

class FullAnimeControllerTest < ActionController::TestCase
  test "can get anime details" do
    get :show, format: :json, id: 'sword-art-online'
    assert_response 200
    assert_equal FullAnimeSerializer.new(anime(:sword_art_online)).to_json, @response.body
  end

  # TODO: needs updating when editing is available to all users
  test "can edit an anime as staff" do
    sign_in users(:josh)

    data = {
      synopsis: "Hello, World!",
      episode_count: 32
    }

    put :update, format: :json, id: 'sword-art-online', full_anime: data
    assert_response 200
    assert_equal 4, Version.count # 3 fixtures + new

    version = Version.last
    assert_equal data[:synopsis], version.object["synopsis"]
    assert_equal data[:episode_count], version.object["episode_count"]
  end
end
