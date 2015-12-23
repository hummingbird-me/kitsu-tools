require 'rails_helper'

RSpec.shared_examples 'episodic' do
  it { should have_db_column(:episode_count) }
  it { should have_db_column(:episode_length) }
  it { should have_many(:episodes) }
  it { should have_many(:streaming_links) }

  describe '#recalculate_episode_length!' do
    it 'should set episode_length to the mode when it is more than 50%' do
      anime = create(:anime, episode_count: 10)
      expect(Episode).to receive(:length_mode) { {mode: 5, count: 8} }
      expect(anime).to receive(:update).with(episode_length: 5)
      anime.recalculate_episode_length!
    end
    it 'should set episode_length to the mean when mode is less than 50%' do
      anime = create(:anime, episode_count: 10)
      allow(Episode).to receive(:length_mode) { {mode: 5, count: 2} }
      expect(Episode).to receive(:length_average) { 10 }
      expect(anime).to receive(:update).with(episode_length: 10)
      anime.recalculate_episode_length!
    end
  end
end
