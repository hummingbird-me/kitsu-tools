# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: library_entries
#
#  id              :integer          not null, primary key
#  media_type      :string           not null, indexed => [user_id, media_id]
#  notes           :text
#  private         :boolean          default(FALSE), not null
#  progress        :integer          default(0), not null
#  rating          :decimal(2, 1)
#  reconsume_count :integer          default(0), not null
#  reconsuming     :boolean          default(FALSE), not null
#  status          :integer          not null, indexed => [user_id]
#  volumes_owned   :integer          default(0), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  media_id        :integer          not null, indexed => [user_id, media_type]
#  user_id         :integer          not null, indexed, indexed => [media_type, media_id], indexed => [status]
#
# Indexes
#
#  index_library_entries_on_user_id                              (user_id)
#  index_library_entries_on_user_id_and_media_type_and_media_id  (user_id,media_type,media_id) UNIQUE
#  index_library_entries_on_user_id_and_status                   (user_id,status)
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe LibraryEntry, type: :model do
  let(:anime) { create(:anime, episode_count: 5) }
  subject { build(:library_entry) }

  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:media) }
  it { should validate_presence_of(:status) }
  it { should validate_presence_of(:progress) }
  it { should validate_presence_of(:reconsume_count) }
  it do
    expect(subject).to validate_uniqueness_of(:user_id)
      .scoped_to(%i[media_type media_id])
  end
  it do
    expect(subject).to validate_numericality_of(:rating)
      .is_less_than_or_equal_to(5)
      .is_greater_than(0)
  end

  describe 'progress_limit validation' do
    context 'with known progress_limit' do
      let(:anime) { create(:anime, episode_count: 5) }
      it 'should fail when progress > progress_limit' do
        library_entry = build(:library_entry, media: anime, progress: 6)
        expect(library_entry).not_to be_valid
        expect(library_entry.errors[:progress]).to be_present
      end
      it 'should pass when progress <= progress_limit' do
        library_entry = build(:library_entry, media: anime, progress: 4)
        library_entry.valid?
        expect(library_entry.errors[:progress]).to be_blank
      end
    end
    context 'without known progress_limit' do
      let(:anime) { create(:anime, episode_count: nil) }
      it 'should fail when progress > default_progress_limit' do
        library_entry = build(:library_entry, media: anime, progress: 6)
        expect(anime).to receive(:default_progress_limit).and_return(5).once
        expect(library_entry).not_to be_valid
        expect(library_entry.errors[:progress]).to be_present
      end
      it 'should pass when progress <= default_progress_limit' do
        library_entry = build(:library_entry, media: anime, progress: 4)
        expect(anime).to receive(:default_progress_limit).and_return(5).once
        library_entry.valid?
        expect(library_entry.errors[:progress]).to be_blank
      end
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

  describe 'updating rating_frequencies on media after save' do
    context 'with a previous value' do
      it 'should decrement the previous frequency' do
        library_entry = create(:library_entry, rating: 3.5)
        media = library_entry.media
        expect {
          library_entry.rating = 4.0
          library_entry.save!
        }.to change { media.reload.rating_frequencies['3.5'].to_i }.by(-1)
      end
      it 'should increment the new frequency' do
        library_entry = create(:library_entry, rating: 3.5)
        media = library_entry.media
        expect {
          library_entry.rating = 4.0
          library_entry.save!
        }.to change { media.reload.rating_frequencies['4.0'].to_i }.by(1)
      end
    end
    context 'without a previous value' do
      it 'should not send any frequencies negative' do
        library_entry = create(:library_entry, rating: 3.5)
        media = library_entry.media
        library_entry.rating = 4.0
        library_entry.save!
        media.reload
        freqs = media.rating_frequencies.transform_values(&:to_i)
        expect(freqs.values).to all(be_positive.or(be_zero))
      end
    end
  end
end
