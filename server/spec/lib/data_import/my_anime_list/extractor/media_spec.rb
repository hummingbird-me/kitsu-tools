require 'rails_helper'

RSpec.describe DataImport::MyAnimeList::Extractor::Media do
  let(:tv) { fixture('my_anime_list/cowboy-bebop-tv.json') }
  let(:movie) { fixture('my_anime_list/cowboy-bebop-movie.json') }

  subject { described_class.new(tv) }

  describe '#age_rating' do
    it 'should be a symbol' do
      expect(subject.age_rating).to be_a(Symbol)
    end

    it 'should return the rating' do
      expect(subject.age_rating).to eq(:R)
    end
  end

  describe '#episode_count' do
    context 'for a tv show' do
      it 'should return the number of episodes' do
        expect(subject.episode_count).to eq(26)
      end
    end

    context 'for a movie' do
      subject { described_class.new(movie) }

      it 'should return 1' do
        expect(subject.episode_count).to eq(1)
      end
    end
  end

  describe '#episode_length' do
    it 'should return the runtime in minutes' do
      expect(subject.episode_length).to eq(24)
    end
  end

  describe '#synopsis' do
    it 'should return the plaintext synopsis' do
      expected_synopsis = "<p>In fake data with some spoiler </p><p><span class=\"spoiler\"><br> I am a spoiler!</span></p> <p>[Written by MAL Rewrite]</p>"
      expect(subject.synopsis).to eq(expected_synopsis)
    end
  end

  describe '#youtube_video_id' do
    it 'should return a youtube link' do
      expect(subject.youtube_video_id).to eq("http://www.youtube.com/embed/qig4KOK2R2g")
    end
  end

  describe '#poster_image' do
    it 'should return an image link' do
      expect(subject.poster_image).to eq("http://cdn.myanimelist.net/images/anime/4/19644.jpg")
    end
  end

  describe '#average_rating' do
    # members_score
    it 'should be a float' do
      expect(subject.average_rating).to be_a(Float)
    end

    it 'should return the average' do
      expect(subject.average_rating).to eq(8.83)
    end
  end

  describe '#user_count' do
    # members_count
    it 'should return members count' do
      expect(subject.user_count).to eq(431480)
    end
  end

  describe '#age_rating_guide' do
    # need to check if this is genres, or what it is.
  end


  describe '#show_type' do
    it 'should return a Symbol' do
      expect(subject.show_type).to be_a(Symbol)
    end

    context 'for a tv show' do
      it 'should return the type' do
        expect(subject.show_type).to eq(:tv)
      end
    end

    context 'for a movie' do
      subject { described_class.new(movie) }

      it 'should return the type' do
        expect(subject.show_type).to eq(:movie)
      end
    end
  end


  describe '#start_date' do
    it 'should return a Date object' do
      expect(subject.start_date).to be_a(Date)
    end
    it 'should return the date the first episode aired' do
      # this is a really stupid test imo.
      expect(subject.start_date).to eq("1998-04-03".to_date)
    end
  end

  describe '#end_date' do
    context 'for a tv series' do
      it 'should return the date the series ended' do
        expect(subject.end_date).to eq("1999-04-24".to_date)
      end
    end

    context 'for a movie' do
      subject { described_class.new(movie) }

      it 'should return nil' do
        expect(subject.end_date).to be_nil
      end
    end
  end

  context '#genres' do
    it 'should return an array of genre strings' do
      # expect(subject.genres).to eq(%w[Action Sci-Fi Tokusatsu])
    end
  end

  describe '#titles' do
    it 'should return the Romaji title of media' do
      expect(subject.titles[:en_jp]).to eq('Cowboy Bebop')
    end
    it 'should return the English title of media' do
      expect(subject.titles[:en_us]).to eq('Cowboy Bebop')
    end
    it 'should return the Japanese title of media' do
      expect(subject.titles[:ja_jp]).to eq('カウボーイビバップ')
    end
    it 'should prevent an error if English or Japanese title does not exist' do
      # not sure how to implement this, was done using try(:first)
    end
  end

  describe '#canonical_title' do
    it 'should link to the primary english title of the media' do
    end
  end

  describe '#abbreviated_titles' do
    it 'should return an array' do
      expect(subject.abbreviated_titles).to be_an(Array)
    end
    it 'should return all synonyms titles' do
      expect(subject.abbreviated_titles).to eq(["COWBOY BEBOP"])
    end
  end



end
