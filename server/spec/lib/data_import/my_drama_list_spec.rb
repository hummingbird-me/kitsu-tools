require 'rails_helper'

RSpec.describe DataImport::MyDramaList do
  subject { described_class.new }
  before do
    host = described_class::MDL_HOST
    stub_request(:get, "#{host}/123").
      to_return(body: fixture('my_drama_list/karate-robo-zaborgar.html'))
    stub_request(:get, "#{host}/123/cast").
      to_return(body: fixture('my_drama_list/karate-robo-zaborgar-cast.html'))
    stub_request(:get, "#{host}/123/episodes").
      to_return(body: fixture('my_drama_list/signal-episodes.html'))
    stub_request(:get, /i.mdldb.net/).
      to_return(body: fixture('image.png'), headers: {
        'Content-Type': 'image/png'
      })
  end

  describe '#get_media' do
    it 'should yield a Media object' do
      expect { |b|
        subject.get_media('123', &b)
        subject.run
      }.to yield_with_args(Media)
    end
    it 'should have assigned attributes onto the yielded object' do
      subject.get_media('123') do |media|
        expect(media.canonical_title).to eq('Karate-Robo Zaborgar')
      end
      subject.run
    end
    it 'should be valid' do
      subject.get_media('123') do |media|
        expect(media).to be_valid
      end
      subject.run
    end
  end
end
