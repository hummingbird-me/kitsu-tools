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
  include Media

  has_many :library_entries, dependent: :destroy

  enum age_rating: %i[G PG R R18]

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
end
