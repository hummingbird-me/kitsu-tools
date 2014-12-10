require 'test_helper'

class FullMangaControllerTest < ActionController::TestCase
  test "can get manga details" do
    get :show, format: :json, id: 'monster'
    assert_response 200
    assert_equal FullMangaSerializer.new(manga(:monster)).to_json, @response.body
  end

  test "can edit a manga as staff" do
    sign_in users(:josh)

    data = {
      synopsis: "Hello, World!",
      chapter_count: 32,
      edit_comment: "Goodbye, World!"
    }

    put :update, format: :json, id: 'monster', full_manga: data
    assert_response 200
    assert_equal 4, Version.count # 3 fixtures + new

    assert_equal "history", Version.last.state
    assert_equal data[:edit_comment], Version.last.comment

    manga = manga(:monster)
    assert_equal data[:synopsis], manga.synopsis
    assert_equal data[:chapter_count], manga.chapter_count
  end

  test "can edit a manga" do
    sign_in users(:vikhyat)

    data = {
      synopsis: "Hello, World!",
      chapter_count: 32,
      edit_comment: 'Goodbye, World!'
    }

    put :update, format: :json, id: 'monster', full_manga: data
    assert_response 200
    assert_equal 4, Version.count # 3 fixtures + new

    version = Version.last
    assert_equal "pending", version.state
    assert_equal data[:synopsis], version.object['synopsis']
    assert_equal data[:chapter_count], version.object['chapter_count']
    assert_equal data[:edit_comment], version.comment
  end
end
