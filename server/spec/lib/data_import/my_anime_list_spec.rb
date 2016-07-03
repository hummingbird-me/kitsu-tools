require 'rails_helper'

RSpec.describe DataImport::MyAnimeList do
  subject { described_class.new }

  before do
    host = described_class::MDL_HOST
    stub_request(:get, "#{host}/anime/1").
      to_return(body: fixture('my_anime_list/cowboy-bebop-tv.json'))
    stub_request(:get, "#{host}/anime/5").
      to_return(body: fixture('my_anime_list/cowboy-bebop-movie.json'))
    stub_request(:get, "http://cdn.myanimelist.net/images/anime/4/19644.jpg").
      to_return(body: fixture('image.jpg'), headers: {
        'Content-Type': 'image/jpg'
      })
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
        expect(media.canonical_title).to eq('Cowboy Bebop')
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
