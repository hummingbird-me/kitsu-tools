require 'test_helper'
require 'fixture_helper'

require 'list_imports/myanimelist'

class MyAnimeListListImportTest < ActiveSupport::TestCase
  test 'is an enumerable' do
    assert ListImport::MyAnimeList.included_modules.include?(Enumerable)
  end
  test 'enumerates rows properly for anime' do
    list = ListImport::MyAnimeList.new(read_fixture('mal_animelist.xml'))
    list.each do |row|
      required_keys = %i{episodes_watched status media}
      # array subtraction, basically means required_keys - row.keys
      assert_equal [], required_keys.reject { |x| row.include?(x) }
      assert_instance_of Anime, row[:media]
    end
  end
  test 'enumerates rows properly for manga' do
    list = ListImport::MyAnimeList.new(read_fixture('mal_mangalist.xml'))
    list.each do |row|
      required_keys = %i{chapters_read volumes_read status media}
      # array subtraction, basically means required_keys - row.keys
      assert_equal [], required_keys.reject { |x| row.include?(x) }
      assert_instance_of Manga, row[:media]
    end
  end
end
