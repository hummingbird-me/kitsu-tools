# == Schema Information
#
# Table name: anime
#
#  id                        :integer          not null, primary key
#  slug                      :string(255)
#  age_rating                :integer
#  episode_count             :integer
#  episode_length            :integer
#  synopsis                  :text             default(""), not null
#  youtube_video_id          :string(255)
#  mal_id                    :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  cover_image_file_name     :string(255)
#  cover_image_content_type  :string(255)
#  cover_image_file_size     :integer
#  cover_image_updated_at    :datetime
#  average_rating            :float
#  user_count                :integer          default(0), not null
#  thetvdb_series_id         :integer
#  thetvdb_season_id         :integer
#  age_rating_guide          :string(255)
#  show_type                 :integer
#  start_date                :date
#  end_date                  :date
#  rating_frequencies        :hstore           default({}), not null
#  poster_image_file_name    :string(255)
#  poster_image_content_type :string(255)
#  poster_image_file_size    :integer
#  poster_image_updated_at   :datetime
#  cover_image_top_offset    :integer          default(0), not null
#  ann_id                    :integer
#  started_airing_date_known :boolean          default(TRUE), not null
#  titles                    :hstore           default({}), not null
#  canonical_title           :string           default("ja_en"), not null
#  abbreviated_titles        :string           is an Array
#

class Anime < ActiveRecord::Base
  SEASONS = %w[winter spring summer fall]

  include Media
  include AgeRatings
  include Episodic

  has_many :library_entries, dependent: :destroy
  has_many :streaming_links, as: 'media', dependent: :destroy

  update_index('media#anime') { self }

  def slug_candidates
    # Prefer the canonical title or romaji title before anything else
    candidates = [
      -> { canonical_title }, # attack-on-titan
      -> { titles[:ja_en] } # shingeki-no-kyojin
    ]
    if show_type == 'TV'
      # If it's a TV show with a name collision, common practice is to
      # specify the year (ex: kanon-2006)
      candidates << -> { [titles[:ja_en], year] }
    else
      # If it's not TV and it's having a name collision, it's probably the
      # movie or OVA for a series (ex: shingeki-no-kyojin-movie)
      candidates << -> { [titles[:ja_en], show_type] }
      candidates << -> { [titles[:ja_en], show_type, year] }
    end
    candidates
  end

  def season
    case start_date.try(:month)
    when 12, 1, 2; :winter
    when 3, 4, 5; :spring
    when 6, 7, 8; :summer
    when 9, 10, 11; :fall
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
