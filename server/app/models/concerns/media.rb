module Media
  extend ActiveSupport::Concern

  included do
    extend FriendlyId
    include Titleable
    include Rateable

    friendly_id :slug_candidates, use: %i[slugged finders history]
    resourcify

    # HACK: we need to return a relation but want to handle historical slugs
    scope :by_slug, -> (slug) {
      record = where(slug: slug)
      record = where(id: friendly.find(slug).id) if record.empty?
      record
    }

    has_attached_file :cover_image
    has_attached_file :poster_image

    has_and_belongs_to_many :genres
    has_many :castings, as: 'media'
    has_many :installments, as: 'media'
    has_many :franchises, through: :installments

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
