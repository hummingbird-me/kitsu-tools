require 'test_helper'

class MangaLibraryEntryTest < ActiveSupport::TestCase

  fixtures :users, :manga, :manga_library_entry
  
  should belong_to(:user)
  should belong_to(:manga)
  should validate_presence_of(:user)
  should validate_presence_of(:manga)
  should validate_presence_of(:status)
  should validate_uniqueness_of(:user).scoped_to(:manga)
  should ensure_inclusion_of(:status).in_array(["Currently Reading", "Plan to Read", "Completed", "On Hold", "Dropped"])

  test "accepts only valid ratings" do
    entry = MangaLibraryEntry.first
    [-1, 0, 0.1].each do |i|
      entry.rating = i
      assert !entry.valid?, "#{i} is invalid"
    end
    [0.5, nil, 5].each do |i|
      entry.rating = i
      assert entry.valid?, "#{i} is valid"
    end
  end

  test "should not allow exceeding total number of chapters" do
    MangaLibraryEntry.find_each do |entry| 
      total = entry.manga.chapter_count
      entry.chapters_readed = total
      entry.save
      entry.chapters_readed = total + 1
      entry.save
      assert_equal total, entry.reload.chapters_readed
    end
  end

  test "should not allow exceeding total number of volumes" do
    MangaLibraryEntry.find_each do |entry| 
      total = entry.manga.volume_count
      entry.volumes_readed = total
      entry.save
      entry.volumes_readed = total + 1
      entry.save
      assert_equal total, entry.reload.volumes_readed
    end
  end
end
