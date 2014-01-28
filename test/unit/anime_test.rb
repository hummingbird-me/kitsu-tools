# == Schema Information
#
# Table name: anime
#
#  id                        :integer          not null, primary key
#  title                     :string(255)
#  alt_title                 :string(255)
#  slug                      :string(255)
#  age_rating                :string(255)
#  episode_count             :integer
#  episode_length            :integer
#  synopsis                  :text
#  youtube_video_id          :string(255)
#  mal_id                    :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  cover_image_file_name     :string(255)
#  cover_image_content_type  :string(255)
#  cover_image_file_size     :integer
#  cover_image_updated_at    :datetime
#  bayesian_average          :float            default(0.0)
#  user_count                :integer
#  thetvdb_series_id         :string(255)
#  thetvdb_season_id         :string(255)
#  english_canonical         :boolean          default(FALSE)
#  age_rating_guide          :string(255)
#  show_type                 :string(255)
#  started_airing_date       :date
#  finished_airing_date      :date
#  rating_frequencies        :hstore           default({}), not null
#  poster_image_file_name    :string(255)
#  poster_image_content_type :string(255)
#  poster_image_file_size    :integer
#  poster_image_updated_at   :datetime
#  cover_image_top_offset    :integer
#  ann_id                    :integer
#  started_airing_date_known :boolean          default(TRUE)
#

require 'test_helper'

class AnimeTest < ActiveSupport::TestCase
  should have_many(:quotes).dependent(:destroy)
  should have_many(:castings).dependent(:destroy)
  should have_many(:reviews).dependent(:destroy)
  should have_many(:gallery_images).dependent(:destroy)
  should have_many(:watchlists).dependent(:destroy)
  should have_and_belong_to_many(:genres)
  should have_and_belong_to_many(:producers)
  should have_and_belong_to_many(:franchises)
  should validate_presence_of(:title)
  should validate_uniqueness_of(:title)

  test "should implement search scopes" do
    assert Anime.fuzzy_search_by_title("swodr atr onlien").include?(anime(:sword_art_online))
    assert Anime.simple_search_by_title("sword art").include?(anime(:sword_art_online))
  end
end
