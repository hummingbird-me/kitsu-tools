require 'rails_helper'

RSpec.describe DataImport::MyAnimeList do
  subject { described_class.new }

  before do
    host = described_class::MDL_HOST
    stub_request(:get, "#{host}/anime/1").
      to_return(body: fixture('my_anime_list/cowboy-bebop-tv.json'))
    stub_request(:get, "#{host}/anime/5").
      to_return(body: fixture('my_anime_list/cowboy-bebop-movie.json'))
  end

  describe '#get_media' do
    it 'should yield a Media object' do
      expect { |b|
        subject.get_media('/anime/1', &b)
        subject.run
      }.to yield_with_args(Media)
    end
    it 'should have assigned attributes onto the yielded object' do
      subject.get_media('/anime/1') do |media|
        expect(media.canonical_title).to eq('not sure') # not sure..
      end
      subject.run
    end
    it 'should be valid' do
      subject.get_media('/anime/1') do |media|
        expect(media).to be_valid
      end
      subject.run
    end
  end



end
