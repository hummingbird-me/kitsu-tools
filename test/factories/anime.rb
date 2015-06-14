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
#  synopsis                  :text             default(""), not null
#  youtube_video_id          :string(255)
#  mal_id                    :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  cover_image_file_name     :string(255)
#  cover_image_content_type  :string(255)
#  cover_image_file_size     :integer
#  cover_image_updated_at    :datetime
#  bayesian_rating           :float            default(0.0), not null
#  user_count                :integer          default(0), not null
#  thetvdb_series_id         :integer
#  thetvdb_season_id         :integer
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
#  cover_image_top_offset    :integer          default(0), not null
#  ann_id                    :integer
#  started_airing_date_known :boolean          default(TRUE), not null
#  jp_title                  :text
#

FactoryGirl.define do

  factory :anime do
    title { Faker::Name.name }

    #TODO: Fix fucking factory association
    # after(:create) do |a|
    #   a.genres << create(:genre, anime: [a])
    # end
  end

end
