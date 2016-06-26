module Media
  extend ActiveSupport::Concern

  included do
    extend FriendlyId
    include Titleable
    include Rateable

    # HACK: we need to return a relation but want to handle historical slugs
    scope :by_slug, -> (slug) {
      record = where(slug: slug)
      record = where(id: friendly.find(slug).id) if record.empty?
      record
    }

    friendly_id :slug_candidates, use: %i[slugged finders history]
    resourcify
    has_attached_file :cover_image
    has_attached_file :poster_image
    update_index("media##{name.tableize}") { self }

    has_and_belongs_to_many :genres
    has_many :castings, as: 'media'
    has_many :installments, as: 'media'
    has_many :franchises, through: :installments
    has_many :library_entries, as: 'media', dependent: :destroy
    has_many :mappings, as: 'media', dependent: :destroy
    delegate :year, to: :start_date, allow_nil: true

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
end
