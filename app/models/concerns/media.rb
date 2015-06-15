module Media
  extend ActiveSupport::Concern
  included do
    include Versionable
    include BayesianAverageable
    include PgSearch
    extend FriendlyId

    has_and_belongs_to_many :genres
    with_options(dependent: :destroy) do |a|
      a.has_many :castings, as: :castable
      a.has_many :favorites, as: :item
    end

    VALID_IMAGES ||= %w(image/jpg image/jpeg image/png image/gif)

    has_attached_file :cover_image,
                      styles: { thumb: ['1400x900>', :jpg] },
                      convert_options: { thumb: '-quality 90' },
                      keep_old_files: true

    has_attached_file :poster_image,
                      styles: {
                        large: {
                          geometry: '490x710!',
                          animated: false,
                          format: :jpg
                        },
                        medium: '100x150!'
                      },
                      convert_options: { large: '-quality 0' },
                      default_url: '/assets/missing-anime-cover.jpg',
                      keep_old_files: true

    validates_attachment_content_type :cover_image,
                                      :poster_image,
                                      content_type: self::VALID_IMAGES

    pg_search_scope :instant_search,
                    against: self::PG_TITLE_SCOPE,
                    using: {
                      tsearch: {
                        normalization: 42,
                        prefix: true,
                        dictionary: 'english'
                      }
                    }

    pg_search_scope :full_search,
                    against: self::PG_TITLE_SCOPE,
                    using: {
                      tsearch: {
                        normalization: 42,
                        dictionary: 'english'
                      },
                      trigram: { threshold: 0.1 }
                    },
                    # Combine trigram and tsearch values
                    ranked_by: ':tsearch + :trigram'
  end
end
