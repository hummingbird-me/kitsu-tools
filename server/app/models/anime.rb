# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: anime
#
#  id                        :integer          not null, primary key
#  abbreviated_titles        :string           is an Array
#  age_rating                :integer          indexed
#  age_rating_guide          :string(255)
#  average_rating            :float            indexed
#  canonical_title           :string           default("en_jp"), not null
#  cover_image_content_type  :string(255)
#  cover_image_file_name     :string(255)
#  cover_image_file_size     :integer
#  cover_image_top_offset    :integer          default(0), not null
#  cover_image_updated_at    :datetime
#  end_date                  :date
#  episode_count             :integer
#  episode_length            :integer
#  poster_image_content_type :string(255)
#  poster_image_file_name    :string(255)
#  poster_image_file_size    :integer
#  poster_image_updated_at   :datetime
#  rating_frequencies        :hstore           default({}), not null
#  show_type                 :integer
#  slug                      :string(255)      indexed
#  start_date                :date
#  started_airing_date_known :boolean          default(TRUE), not null
#  synopsis                  :text             default(""), not null
#  titles                    :hstore           default({}), not null
#  user_count                :integer          default(0), not null, indexed
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  youtube_video_id          :string(255)
#
# Indexes
#
#  index_anime_on_age_rating  (age_rating)
#  index_anime_on_slug        (slug) UNIQUE
#  index_anime_on_user_count  (user_count)
#  index_anime_on_wilson_ci   (average_rating)
#
# rubocop:enable Metrics/LineLength

class Anime < ActiveRecord::Base
  SEASONS = %w[winter spring summer fall].freeze

  include Media
  include AgeRatings
  include Episodic

  enum show_type: %i[TV special OVA ONA movie music]
  has_many :streaming_links, as: 'media', dependent: :destroy

  update_index('media#anime') { self }

  def slug_candidates
    # Prefer the canonical title or romaji title before anything else
    candidates = [
      -> { canonical_title }, # attack-on-titan
      -> { titles[:en_jp] } # shingeki-no-kyojin
    ]
    if show_type == :TV
      # If it's a TV show with a name collision, common practice is to
      # specify the year (ex: kanon-2006)
      candidates << -> { [titles[:en_jp], year] }
    else
      # If it's not TV and it's having a name collision, it's probably the
      # movie or OVA for a series (ex: shingeki-no-kyojin-movie)
      candidates << -> { [titles[:en_jp], show_type] }
      candidates << -> { [titles[:en_jp], show_type, year] }
    end
    candidates
  end

  def season
    case start_date.try(:month)
    when 12, 1, 2 then :winter
    when 3, 4, 5 then :spring
    when 6, 7, 8 then :summer
    when 9, 10, 11 then :fall
    end
  end

  def self.fuzzy_find(title)
    MediaIndex::Anime.query(multi_match: {
      fields: %w[titles.* abbreviated_titles synopsis actors characters],
      query: title,
      fuzziness: 2,
      max_expansions: 15,
      prefix_length: 2
    }).preload.first
  end
end
