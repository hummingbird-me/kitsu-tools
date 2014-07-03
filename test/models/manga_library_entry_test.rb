# == Schema Information
#
# Table name: manga_library_entries
#
#  id            :integer          not null, primary key
#  user_id       :integer          not null
#  manga_id      :integer          not null
#  status        :string(255)      not null
#  private       :boolean          default(FALSE), not null
#  chapters_read :integer          default(0), not null
#  volumes_read  :integer          default(0), not null
#  reread_count  :integer          default(0), not null
#  rereading     :boolean          default(FALSE), not null
#  last_read     :datetime
#  rating        :decimal(2, 1)
#  created_at    :datetime
#  updated_at    :datetime
#  notes         :string(255)
#  imported      :boolean          default(FALSE), not null
#

require 'test_helper'

class MangaLibraryEntryTest < ActiveSupport::TestCase

  test "accepts only valid ratings" do
    entry = MangaLibraryEntry.first
    [-1, 0, 0.1].each do |i|
      entry.rating = i
      assert !entry.valid?, "#{i} should be invalid"
    end
    [0.5, nil, 5].each do |i|
      entry.rating = i
      assert entry.valid?, "#{i} should be valid"
    end
  end

  test "should not allow exceeding total number of chapters" do
    MangaLibraryEntry.find_each do |entry| 
      total = entry.manga.chapter_count
      entry.chapters_read = total
      entry.save
      entry.chapters_read = total + 1
      entry.save
      assert_equal total, entry.reload.chapters_read
    end
  end

  test "should not allow exceeding total number of volumes" do
    MangaLibraryEntry.find_each do |entry| 
      total = entry.manga.volume_count
      entry.volumes_read = total
      entry.save
      entry.volumes_read = total + 1
      entry.save
      assert_equal total, entry.reload.volumes_read
    end
  end
end
