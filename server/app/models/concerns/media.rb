module Media
  extend ActiveSupport::Concern

  included do
    extend FriendlyId
    include Titleable
    friendly_id :slug_candidates, use: %i[slugged finders history]
    resourcify

    has_attached_file :cover_image
    has_attached_file :poster_image

    validates :average_rating, numericality: {
      less_than_or_equal_to: 5,
      greater_than: 0
    }, allow_nil: true
    validates_attachment :cover_image, content_type: {
      content_type: %w[image/jpg image/jpeg image/png]
    }
    validates_attachment :poster_image, content_type: {
      content_type: %w[image/jpg image/jpeg image/png]
    }
  end

  def slug_candidates
    [
      -> { canonical_title },
      -> { titles[:ja_en] }
    ]
  end

  delegate :year, to: :start_date, allow_nil: true
end
