require 'test_helper'

class MangaTest < ActiveSupport::TestCase
  should validate_presence_of(:romaji_title)

  test "should implement search scopes" do
    assert Manga.fuzzy_search_by_title("monstre").include?(manga(:monster)), "manga fuzzy search"
    assert Manga.simple_search_by_title("monster").include?(manga(:monster)), "manga simple search"
  end
end
