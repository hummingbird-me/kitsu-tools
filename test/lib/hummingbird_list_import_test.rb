require 'test_helper'

require 'list_imports/hummingbird'

HUMMINGBACKUP = open(File.realpath('../fixtures/hummingbird-backup.json', __dir__)).read
# Match the fixture IDs because I'm too lazy to figure out the ERB shit lol
HUMMINGBACKUP.gsub!('__SAO_ID__', ActiveRecord::FixtureSet.identify(:sword_art_online).to_s)
HUMMINGBACKUP.gsub!('__MONSTER_ID__', ActiveRecord::FixtureSet.identify(:monster).to_s)

class HummingbirdListImportTest < ActiveSupport::TestCase
  test 'is an enumerable' do
    assert HummingbirdListImport.included_modules.include?(Enumerable)
  end
  test 'enumerates rows properly in anime mode' do
    list = HummingbirdListImport.new(HUMMINGBACKUP, :anime)
    list.each do |row|
      required_keys = %i{episodes_watched status media}
      # array subtraction, basically means required_keys - row.keys
      assert_equal [], required_keys.reject { |x| row.include?(x) }
      assert_instance_of Anime, row[:media]
    end
  end
  test 'enumerates rows properly in manga mode' do
    list = HummingbirdListImport.new(HUMMINGBACKUP, :manga)
    list.each do |row|
      required_keys = %i{chapters_read volumes_read status media}
      # array subtraction, basically means required_keys - row.keys
      assert_equal [], required_keys.reject { |x| row.include?(x) }
      assert_instance_of Manga, row[:media]
    end
  end
end
