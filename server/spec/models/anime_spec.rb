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

require 'rails_helper'

RSpec.describe Anime, type: :model do
  subject { build(:anime) }

  include_examples 'media'
  include_examples 'episodic'
  include_examples 'age_ratings'

  describe '#season' do
    it 'should return winter for shows starting in December through February' do
      dec_anime = build(:anime, start_date: Date.new(2015, 12))
      jan_anime = build(:anime, start_date: Date.new(2016, 1))
      feb_anime = build(:anime, start_date: Date.new(2016, 2))
      expect(dec_anime.season).to eq(:winter)
      expect(jan_anime.season).to eq(:winter)
      expect(feb_anime.season).to eq(:winter)
    end

    it 'should return spring for shows starting in March through May' do
      mar_anime = build(:anime, start_date: Date.new(2016, 3))
      apr_anime = build(:anime, start_date: Date.new(2016, 4))
      may_anime = build(:anime, start_date: Date.new(2016, 5))
      expect(mar_anime.season).to eq(:spring)
      expect(apr_anime.season).to eq(:spring)
      expect(may_anime.season).to eq(:spring)
    end

    it 'should return summer for shows starting in June through August' do
      jun_anime = build(:anime, start_date: Date.new(2016, 6))
      jul_anime = build(:anime, start_date: Date.new(2016, 7))
      aug_anime = build(:anime, start_date: Date.new(2016, 8))
      expect(jun_anime.season).to eq(:summer)
      expect(jul_anime.season).to eq(:summer)
      expect(aug_anime.season).to eq(:summer)
    end

    it 'should return fall for shows starting in September through November' do
      sep_anime = build(:anime, start_date: Date.new(2016, 9))
      oct_anime = build(:anime, start_date: Date.new(2016, 10))
      nov_anime = build(:anime, start_date: Date.new(2016, 11))
      expect(sep_anime.season).to eq(:fall)
      expect(oct_anime.season).to eq(:fall)
      expect(nov_anime.season).to eq(:fall)
    end
  end
end
