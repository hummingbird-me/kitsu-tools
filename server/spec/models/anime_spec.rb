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
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  cover_image_file_name     :string(255)
#  cover_image_content_type  :string(255)
#  cover_image_file_size     :integer
#  cover_image_updated_at    :datetime
#  average_rating            :float
#  user_count                :integer          default(0), not null
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
#  started_airing_date_known :boolean          default(TRUE), not null
#  titles                    :hstore           default({}), not null
#  canonical_title           :string           default("ja_en"), not null
#  abbreviated_titles        :string           is an Array
#

require 'rails_helper'

RSpec.describe Anime, type: :model do
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
