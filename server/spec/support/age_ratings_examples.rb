require 'rails_helper'

RSpec.shared_examples 'age_ratings' do
  it { should have_db_column(:age_rating) }
  it { should have_db_column(:age_rating_guide) }

  describe '#sfw?' do
    it 'should be true for a G-rated show' do
      anime = build(:anime, age_rating: 'G')
      expect(anime).to be_sfw
      expect(anime).not_to be_nsfw
    end
    it 'should be false for an R18-rated show' do
      anime = build(:anime, :nsfw)
      expect(anime).not_to be_sfw
      expect(anime).to be_nsfw
    end
  end

  describe 'sfw scope' do
    it 'should not include any nsfw series' do
      5.times do
        create(:anime, :nsfw)
        create(:anime, age_rating: 'G')
      end
      expect(Anime.sfw.count).to eq(5)
    end
  end
end
