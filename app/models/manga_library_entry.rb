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

class MangaLibraryEntry < ActiveRecord::Base
  belongs_to :user
  belongs_to :manga

  # Internal Constants
  private

  VALID_STATUSES = ["Currently Reading", "Plan to Read", "Completed", "On Hold", "Dropped"]

  public

  validates :user, :manga, :status, :chapters_read, :volumes_read, :reread_count,
    :status, presence: true
  validates :user_id, :uniqueness => { :scope => :manga_id }
  validates :status, inclusion: { in: VALID_STATUSES }
  validate :rating_is_valid
  validate :chapters_read_less_than_total
  validate :volumes_read_less_than_total

  before_validation do
    # Set field defaults
    self.chapters_read = 0 if self.chapters_read.nil?
    self.volumes_read = 0 if self.volumes_read.nil?
    self.reread_count = 0 if self.reread_count.nil?
    self.private = false if self.private.nil?
  end

  before_save do    
    # Rereading logic
    if self.rereading && self.status_changed? && self.status == "Completed"
      self.rereading = false
      self.reread_count += 1
    end
    
    # Set `last_read` field
    if self.chapters_read_changed? || self.volumes_read_changed? || self.status_changed?
      self.last_read = Time.now
    end
  end
  
  after_save do
    # Update users `last_library_update` field
    self.user.update_column :last_library_update, Time.now
  end
  
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
