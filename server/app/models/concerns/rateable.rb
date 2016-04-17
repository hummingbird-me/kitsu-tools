module Rateable
  extend ActiveSupport::Concern

  included do
    validates :average_rating, numericality: {
      less_than_or_equal_to: 5,
      greater_than: 0
    }, allow_nil: true
  end

  def recalculate_rating_frequencies!
    frequencies = LibraryEntry.where(media: self).group(:rating).count.
      transform_keys(&:to_f)
    self.rating_frequencies = frequencies.slice(LibraryEntry::VALID_RATINGS)
  end
end
