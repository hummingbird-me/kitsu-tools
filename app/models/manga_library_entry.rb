class MangaLibraryEntry < ActiveRecord::Base

  attr_accessible :user_id, :manga_id, :status, :rating, :private, :chapters_readed, :volumes_readed, :rereading_count, :rereading, :last_readed
  
  belongs_to :user
  belongs_to :manga

    
  # Internal Constants
  private
  
  VALID_STATUSES = ["Currently Reading", "Plan to Read", "Completed", "On Hold", "Dropped"]

  public
  
  validates :user, :manga, :status, presence: true
  validates :user_id, :uniqueness => { :scope => :manga_id }
  validates :status, inclusion: { in: VALID_STATUSES }
  validate :rating_is_valid
  validate :chapters_readed_less_than_total
  validate :volumes_readed_less_than_total

  private

  def rating_is_valid
    if self.rating and (self.rating <= 0 or self.rating > 5 or (self.rating * 2) % 1 != 0)
      errors.add(:rating, "is not in the valid range")
    end
  end

  def chapters_readed_less_than_total
    if (self.manga.try(:chapter_count) || 0) > 0 and (self.chapters_readed || 0) > self.manga.chapter_count
      errors.add(:chapters_readed, "cannot exceed total number of chapters")
    end
  end

  def volumes_readed_less_than_total
    if (self.manga.try(:volume_count) || 0) > 0 and (self.volumes_readed || 0) > self.manga.volume_count
      errors.add(:volumes_readed, "cannot exceed total number of volumes")
    end
  end
end
