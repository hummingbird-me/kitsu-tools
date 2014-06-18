class Consuming < ActiveRecord::Base

  # Associations
  belongs_to :user
  belongs_to :item, polymorphic: true
  
  # Internal Constants
  private
  
  VALID_STATUSES = ["Currently Watching", "Plan to Watch", "Completed", "On Hold", "Dropped"]

  public
  
  validates :user, :item, :status, presence: true
  validates :user_id, :uniqueness => { :scope => [:item_id, :item_type] }
  validates :status, inclusion: { in: VALID_STATUSES }
  validate :rating_is_valid
  validate :parts_watched_less_than_total
  validate :blocks_watched_less_than_total

  private

  def rating_is_valid
    if self.rating and (self.rating <= 0 or self.rating > 5 or (self.rating * 2) % 1 != 0)
      errors.add(:rating, "is not in the valid range")
    end
  end

  def parts_watched_less_than_total
    total = 0
    total = self.item.chapter_count if self.item.try(:chapter_count) # If is a manga
    total = self.item.episode_count if self.item.try(:episode_count) # If is an anime
    unless 0 <= self.parts_consumed and self.parts_consumed <= total
      errors.add(:parts_consumed, "cannot exceed total number of parts")
    end
  end

  def blocks_watched_less_than_total
    total = 0
    total = self.item.volume_count if self.item.try(:volume_count) # If is a manga
    total = self.item.season_count if self.item.try(:season_count) # If is an anime
    unless 0 <= self.blocks_consumed and self.blocks_consumed <= total
      errors.add(:blocks_consumed, "cannot exceed total number of parts")
    end
  end

  public


end
