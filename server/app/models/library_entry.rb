# == Schema Information
#
# Table name: library_entries
#
#  id              :integer          not null, primary key
#  user_id         :integer          not null
#  media_id        :integer          not null
#  status          :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  progress        :integer          default(0), not null
#  rating          :decimal(2, 1)
#  private         :boolean          default(FALSE), not null
#  notes           :text
#  reconsume_count :integer          default(0), not null
#  reconsuming     :boolean          default(FALSE), not null
#  media_type      :string           not null
#  volumes_owned   :integer          default(0), not null
#

class LibraryEntry < ActiveRecord::Base
  # TODO: apply this globally so that we can easily update it to add the
  # totally definitely happening 1000-point scale.  Or just because it's good
  # practice.
  VALID_RATINGS = (0.5..5).step(0.5).to_a.freeze

  belongs_to :user, touch: true
  belongs_to :media, polymorphic: true

  enum status: {
    current: 1,
    planned: 2,
    completed: 3,
    on_hold: 4,
    dropped: 5
  }

  validates :user, :media, :status, :progress, :reconsume_count,
    presence: true
  validates :user_id, uniqueness: { scope: %i[media_type media_id] }
  validates :rating, numericality: {
    greater_than: 0,
    less_than_or_equal_to: 5
  }, allow_blank: true
  validates :reconsume_count, numericality: {
    less_than_or_equal_to: 50,
    message: 'just... go outside'
  }
  validate :progress_limit
  validate :rating_on_halves

  def progress_limit
    return unless progress
    progress_cap = media.try(:progress_limit)
    default_cap = "#{media_type}::DEFAULT_PROGRESS_LIMIT".safe_constantize

    if progress_cap && progress > progress_cap
      errors.add(:progress, 'cannot exceed length of media')
    elsif default_cap && progress > default_cap
      errors.add(:progress, 'is rather unreasonably high')
    end
  end

  def rating_on_halves
    return unless rating

    errors.add(:rating, 'must be a multiple of 0.5') unless rating % 0.5 == 0.0
  end

  after_save do
    if rating_changed?
      media.transaction do
        media.decrement_rating_frequency(rating_was)
        media.increment_rating_frequency(rating)
      end
    end
  end
end
