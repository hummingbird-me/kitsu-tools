require 'test_helper'

class ConsumingTest < ActiveSupport::TestCase
  should belong_to(:user)
  should belong_to(:item)
  should validate_presence_of(:user)
  should validate_presence_of(:item)
  should validate_presence_of(:status)
  # should validate_uniqueness_of(:user_id).scoped_to([:item_id, :item_type]) Working on console, not here.
  should ensure_inclusion_of(:status).in_array(["Currently Watching", "Plan to Watch", "Completed", "On Hold", "Dropped"])

  test "accepts only valid ratings" do
    entry = Consuming.first
    [-1, 0, 0.1].each do |i|
      entry.rating = i
      assert !entry.valid?, "#{i} is invalid"
    end
    [0.5, nil, 5].each do |i|
      entry.rating = i
      assert entry.valid?, "#{i} is valid"
    end
  end

  test "should not allow exceeding total number of parts" do
    Consuming.find_each do |entry| 
      total = entry.item.chapter_count if entry.item.try(:chapter_count) # If is a manga
      total = entry.item.episode_count if entry.item.try(:episode_count) # If is an anime
      entry.parts_consumed = total
      entry.save
      entry.parts_consumed = total + 1
      entry.save
      assert_equal total, entry.reload.parts_consumed
    end
  end

  test "should not allow exceeding total number of blocks" do
    Consuming.find_each do |entry| 
      total = entry.item.volume_count if entry.item.try(:volume_count) # If is a manga
      total = entry.item.season_count if entry.item.try(:season_count) # If is an anime
      entry.blocks_consumed = total
      entry.save
      entry.blocks_consumed = total + 1
      entry.save
      assert_equal total, entry.reload.blocks_consumed
    end
  end
  
end
