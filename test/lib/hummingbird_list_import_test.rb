require 'test_helper'
require 'fixture_helper'

require 'list_imports/hummingbird'

HUMMINGBACKUP = read_fixture('hummingbird-backup.json')

class HummingbirdListImportTest < ActiveSupport::TestCase
  test 'is an enumerable' do
    assert ListImport::Hummingbird.included_modules.include?(Enumerable)
  end
  test 'enumerates rows properly in anime mode' do
    list = ListImport::Hummingbird.new(HUMMINGBACKUP, :anime)
    list.each do |row|
      required_keys = %i{episodes_watched status media}
      # array subtraction, basically means required_keys - row.keys
      assert_equal [], required_keys.reject { |x| row.include?(x) }
      assert_instance_of Anime, row[:media]
    end
  end
  test 'enumerates rows properly in manga mode' do
    list = ListImport::Hummingbird.new(HUMMINGBACKUP, :manga)
    list.each do |row|
      required_keys = %i{chapters_read volumes_read status media}
      # array subtraction, basically means required_keys - row.keys
      assert_equal [], required_keys.reject { |x| row.include?(x) }
      assert_instance_of Manga, row[:media]
    end
  end
end
