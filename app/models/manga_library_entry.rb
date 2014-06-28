# == Schema Information
#
# Table name: manga_library_entries
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  manga_id      :integer
#  status        :string(255)
#  private       :boolean          default(FALSE)
#  chapters_read :integer          default(0)
#  volumes_read  :integer          default(0)
#  reread_count  :integer          default(0)
#  rereading     :boolean          default(FALSE)
#  last_read     :datetime
#  rating        :decimal(2, 1)
#  created_at    :datetime
#  updated_at    :datetime
#

class MangaLibraryEntry < ActiveRecord::Base

  attr_accessible :user_id, :manga_id, :status, :rating, :private, :chapters_read, :volumes_read, :reread_count, :rereading, :last_read
  
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
  validate :chapters_read_less_than_total
  validate :volumes_read_less_than_total

  private

  def rating_is_valid
    if self.rating and (self.rating <= 0 or self.rating > 5 or (self.rating * 2) % 1 != 0)
      errors.add(:rating, "is not in the valid range")
    end
  end

  def chapters_read_less_than_total
    if (self.manga.try(:chapter_count) || 0) > 0 and (self.chapters_read || 0) > self.manga.chapter_count
      errors.add(:chapters_read, "cannot exceed total number of chapters")
    end
  end

  def volumes_read_less_than_total
    if (self.manga.try(:volume_count) || 0) > 0 and (self.volumes_read || 0) > self.manga.volume_count
      errors.add(:volumes_read, "cannot exceed total number of volumes")
    end
  end
end
