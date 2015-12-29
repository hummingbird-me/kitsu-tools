# == Schema Information
#
# Table name: library_entries
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  anime_id         :integer
#  status           :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  episodes_watched :integer          default(0), not null
#  rating           :decimal(2, 1)
#  private          :boolean          default(FALSE)
#  notes            :text
#  rewatch_count    :integer          default(0), not null
#  rewatching       :boolean          default(FALSE), not null
#

class LibraryEntry < ActiveRecord::Base
  # TODO: apply this globally so that we can easily update it to add the
  # totally definitely happening 1000-point scale.  Or just because it's good
  # practice.
  VALID_RATINGS = (0.5..5).step(0.5).to_a

  belongs_to :user, touch: true
  belongs_to :anime

  enum status: {
    current: 1,
    planned: 2,
    completed: 3,
    on_hold: 4,
    dropped: 5
  }

  validates :user, :anime, :status, :episodes_watched, :rewatch_count,
    presence: true
  validates :user_id, uniqueness: { scope: :anime_id }
  validates :rating, numericality: {
    greater_than: 0,
    less_than_or_equal_to: 5
  }, allow_blank: true
  validates :rewatch_count, numericality: {
    less_than_or_equal_to: 50,
    message: 'just... go outside'
  }
  validates :episodes_watched, numericality: {
    less_than_or_equal_to: 500,
    message: 'it seems improbable that the show would have that many episodes'
  }
  validate :episodes_watched_limit
  validate :rating_on_halves

  def episodes_watched_limit
    episode_count = anime.try(:episode_count)
    if episode_count && episodes_watched > episode_count
      errors.add(:episodes_watched, 'cannot exceed total number of episodes')
    end
  end
  def rating_on_halves
    return unless rating

    unless rating % 0.5 == 0.0
      errors.add(:rating, 'must be a multiple of 0.5')
    end
  end
end
