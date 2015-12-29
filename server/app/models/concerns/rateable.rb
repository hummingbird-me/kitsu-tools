module Rateable
  extend ActiveSupport::Concern

  included do
    validates :average_rating, numericality: {
      less_than_or_equal_to: 5,
      greater_than: 0
    }, allow_nil: true
  end

  def recalculate_rating_frequencies!
    frequencies = LibraryEntry::VALID_RATINGS.map do |rating|
      [rating, LibraryEntry.where(anime: self, rating: rating).count]
    end
    self.rating_frequencies = Hash[frequencies]
  end
end
