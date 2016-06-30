require 'rails_helper'

RSpec.describe DataImport::MyAnimeList do
  subject { described_class.new }

  before do
    host = described_class::MDL_HOST
    stub_request(:get, "#{host}/anime/1").
      to_return(body: fixture('my_anime_list/cowboy-bebop.json'))
  end

  describe '#get_media' do
    it 'should yield a Media object' do
      expect { |b|
        subject.get_media('/anime/1', &b)
        subject.run
      }.to yield_with_args(Media)
    end
  end



end
