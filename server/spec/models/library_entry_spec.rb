# == Schema Information
#
# Table name: library_entries
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  anime_id         :integer
#  status           :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  episodes_watched :integer          default(0), not null
#  rating           :decimal(2, 1)
#  private          :boolean          default(FALSE)
#  notes            :text
#  rewatch_count    :integer          default(0), not null
#  rewatching       :boolean          default(FALSE), not null
#

require 'rails_helper'

RSpec.describe LibraryEntry, type: :model do
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:anime) }
  it { should validate_presence_of(:status) }
  it { should validate_presence_of(:episodes_watched) }
  it { should validate_presence_of(:rewatch_count) }
  it { should validate_uniqueness_of(:user_id).scoped_to(:anime_id) }
  it {
    should validate_numericality_of(:rating)
      .is_less_than_or_equal_to(5)
      .is_greater_than(0)
  }

  describe 'episodes_watched_limit validation' do
    it 'should fail when episodes_watched > episode_count' do
      anime = create(:anime, episode_count: 5)
      library_entry = build(:library_entry, anime: anime, episodes_watched: 6)
      expect(library_entry).not_to be_valid
      expect(library_entry.errors[:episodes_watched]).to be_present
    end
    it 'should pass when episodes_watched <= episode_count' do
      anime = create(:anime, episode_count: 5)
      library_entry = build(:library_entry, anime: anime, episodes_watched: 4)
      expect(library_entry.errors[:episodes_watched]).to be_blank
    end
  end

  describe 'rating_on_halves validation' do
    it 'should fail when rating is not divisible by 0.5' do
      library_entry = build(:library_entry, rating: 3.14)
      expect(library_entry).not_to be_valid
      expect(library_entry.errors[:rating]).to be_present
    end
    it 'should pass when rating is divisible by 0.5' do
      library_entry = build(:library_entry, rating: 3.5)
      expect(library_entry.errors[:rating]).to be_blank
    end
  end
end
