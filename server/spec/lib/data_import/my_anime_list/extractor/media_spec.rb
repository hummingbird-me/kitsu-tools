require 'rails_helper'

RSpec.describe DataImport::MyAnimeList::Extractor::Media do
  let(:tv) { fixture('my_anime_list/cowboy-bebop-tv.json') }
  let(:movie) { fixture('my_anime_list/cowboy-bebop-movie.json') }
  let(:manga) { fixture('my_anime_list/berserk-manga.json') }

  subject { described_class.new(tv) }
  context 'Anime' do
    describe '#age_rating' do
      it 'should be a symbol' do
        expect(subject.age_rating).to be_a(Symbol)
      end

      it 'should extract the G rating' do
        subject = described_class.new({
          classification: 'G - All Ages'
        }.to_json)
        expect(subject.age_rating).to eq(:G)
      end

      it 'should convert TV-Y7 rating to G' do
        subject = described_class.new({
          classification: 'TV-Y7 - All Ages'
        }.to_json)
        expect(subject.age_rating).to eq(:G)
      end

      it 'should extract the PG rating' do
        subject = described_class.new({
          classification: 'PG - Children'
        }.to_json)
        expect(subject.age_rating).to eq(:PG)
      end

      it 'should convert the PG13 rating to PG' do
        subject = described_class.new({
          classification: 'PG13 - Teens 13 or older'
        }.to_json)
        expect(subject.age_rating).to eq(:PG)
      end

      # this exists in fixture
      it 'should extract the R rating' do
        expect(subject.age_rating).to eq(:R)
      end

      it 'should convert the R+ rating to R' do
        subject = described_class.new({
          classification: 'R+ - Mild Nudity'
        }.to_json)
        expect(subject.age_rating).to eq(:R)
      end

      it 'should extract the R18 rating' do
        subject = described_class.new({
          classification: 'Rx - Hentai'
        }.to_json)
        expect(subject.age_rating).to eq(:R18)
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
        expected_synopsis = <<~EOF.gsub(/\s+/, ' ')
          <p>In fake data with some spoiler </p>
          <p><span class=\"spoiler\"><br> I am a
          spoiler!</span></p>
          <p>[Written by MAL Rewrite]</p>
        EOF
        expect(subject.synopsis).to eq(expected_synopsis)
      end
    end

    describe '#youtube_video_id' do
      it 'should return the end of the youtube link' do
        expect(subject.youtube_video_id).to eq('qig4KOK2R2g')
      end
    end

    describe '#poster_image' do
      it 'should return an image link' do
        expect(subject.poster_image).to eq('http://cdn.myanimelist.net/images/anime/4/19644.jpg')
      end
    end

    describe '#age_rating_guide' do
      it 'should extract the G rating description' do
        subject = described_class.new({
          classification: 'G - All Ages'
        }.to_json)
        expect(subject.age_rating_guide).to eq('All Ages')
      end

      it 'should extract the PG rating description' do
        subject = described_class.new({
          classification: 'PG - Children'
        }.to_json)
        expect(subject.age_rating_guide).to eq('Children')
      end

      # check both cases
      it 'should extract the PG13 & PG-13 rating description' do
        subject = described_class.new({
          classification: 'PG13 - Teens 13 or older'
        }.to_json)
        subject1 = described_class.new({
          classification: 'PG-13 - Teens 13 or older'
        }.to_json)

        expect(subject.age_rating_guide).to eq('Teens 13 or older')
        expect(subject1.age_rating_guide).to eq('Teens 13 or older')
      end

      # this exists in fixture
      it 'should extract the R rating description' do
        expect(subject.age_rating_guide).to eq('Violence, Profanity')
      end

      it 'should extract the R+ rating description' do
        subject = described_class.new({
          classification: 'R+ - Mild Nudity'
        }.to_json)
        expect(subject.age_rating_guide).to eq('Mild Nudity')
      end

      it 'should extract the Rx rating description' do
        subject = described_class.new({
          classification: 'Rx - Hentai'
        }.to_json)
        expect(subject.age_rating_guide).to eq('Hentai')
      end

      it 'case statement for G' do
        subject = described_class.new({
          classification: 'G'
        }.to_json)
        expect(subject.age_rating_guide).to eq('All Ages')
      end

      it 'case statement for PG' do
        subject = described_class.new({
          classification: 'PG'
        }.to_json)
        expect(subject.age_rating_guide).to eq('Children')
      end

      it 'case statement for PG13 & PG-13' do
        subject = described_class.new({
          classification: 'PG13'
        }.to_json)
        subject1 = described_class.new({
          classification: 'PG-13'
        }.to_json)

        expect(subject.age_rating_guide).to eq('Teens 13 or older')
        expect(subject1.age_rating_guide).to eq('Teens 13 or older')
      end

      # it 'case statement for R' do
      #   subject = described_class.new({classification: 'R'}.to_json)
      #   expect(subject.age_rating_guide).to eq('Violence, Profanity')
      # end

      it 'case statement for R+' do
        subject = described_class.new({
          classification: 'R+'
        }.to_json)
        expect(subject.age_rating_guide).to eq('Mild Nudity')
      end

      it 'case statement for Rx' do
        subject = described_class.new({
          classification: 'Rx'
        }.to_json)
        expect(subject.age_rating_guide).to eq('Hentai')
      end
    end

    describe '#subtype' do
      it 'should return a Symbol' do
        expect(subject.subtype).to be_a(Symbol)
      end

      it 'should return tv show' do
        expect(subject.subtype).to eq(:TV)
      end

      it 'should return special' do
        subject = described_class.new({
          type: 'Special'
        }.to_json)
        expect(subject.subtype).to eq(:special)
      end

      it 'should return OVA' do
        subject = described_class.new({
          type: 'OVA'
        }.to_json)
        expect(subject.subtype).to eq(:OVA)
      end

      it 'should return ONA' do
        subject = described_class.new({
          type: 'ONA'
        }.to_json)
        expect(subject.subtype).to eq(:ONA)
      end

      it 'should return movie' do
        subject = described_class.new(movie)
        expect(subject.subtype).to eq(:movie)
      end

      it 'should return music' do
        subject = described_class.new({
          type: 'Music'
        }.to_json)
        expect(subject.subtype).to eq(:music)
      end
    end

    describe '#start_date' do
      it 'should return a Date object' do
        expect(subject.start_date).to be_a(Date)
      end
      it 'should return the date the first episode aired' do
        # this is a really stupid test imo.
        expect(subject.start_date).to eq('1998-04-03'.to_date)
      end
    end

    describe '#end_date' do
      context 'for a tv series' do
        it 'should return the date the series ended' do
          expect(subject.end_date).to eq('1999-04-24'.to_date)
        end
      end

      context 'for a movie' do
        subject { described_class.new(movie) }

        it 'should return nil' do
          expect(subject.end_date).to be_nil
        end
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
      it 'should return nil if English or Japanese title does not exist' do
        subject = described_class.new({ other_titles: {} }.to_json)

        expect(subject.titles[:en_us]).to be_nil
        expect(subject.titles[:ja_jp]).to be_nil
      end
    end

    describe '#abbreviated_titles' do
      it 'should return an array' do
        expect(subject.abbreviated_titles).to be_an(Array)
      end
      it 'should return all synonyms titles' do
        expect(subject.abbreviated_titles).to eq(['COWBOY BEBOP'])
      end
    end

    describe '#genres' do
      it 'should return an array' do
        expect(subject.genres).to be_an(Array)
      end

      it 'should return all genres' do
        expect(subject.genres).to eq(%w[Action Adventure Comedy
                                        Drama Sci-Fi Space])
      end
    end

    describe '#to_h' do
      it 'should return a Hash' do
        expect(subject.to_h).to be_a(Hash)
      end
    end
  end

  context 'Manga' do
    subject { described_class.new(manga) }

    describe '#synopsis' do
      it 'should return the plaintext synopsis' do
        expected_synopsis = <<~EOF.gsub(/\s+/, ' ')
          <p>Guts, a former mercenary now known
          as the \"Black Swordsman,\" is out for revenge.</p>
        EOF
        expect(subject.synopsis).to eq(expected_synopsis)
      end
    end

    describe '#poster_image' do
      it 'should return an image link' do
        expect(subject.poster_image).to eq('http://cdn.myanimelist.net/images/manga/1/157931.jpg')
      end
    end

    describe '#subtype' do
      it 'should return a Symbol' do
        expect(subject.subtype).to be_a(Symbol)
      end

      it 'should return manga' do
        expect(subject.subtype).to eq(:manga)
      end

      it 'should return novel' do
        subject = described_class.new({
          type: 'Novel'
        }.to_json)
        expect(subject.subtype).to eq(:novel)
      end

      it 'should return manuha' do
        subject = described_class.new({
          type: 'Manuha'
        }.to_json)
        expect(subject.subtype).to eq(:manuha)
      end

      it 'should return oneshot' do
        subject = described_class.new({
          type: 'oneshot'
        }.to_json)
        expect(subject.subtype).to eq(:oneshot)
      end

      it 'should return doujin' do
        subject = described_class.new({
          type: 'Doujin'
        }.to_json)
        expect(subject.subtype).to eq(:doujin)
      end
    end

    describe '#titles' do
      it 'should return the Romaji title of media' do
        expect(subject.titles[:en_jp]).to eq('Berserk')
      end
      it 'should return the English title of media' do
        expect(subject.titles[:en_us]).to eq('Berserk')
      end
      it 'should return the Japanese title of media' do
        expect(subject.titles[:ja_jp]).to eq('ベルセルク')
      end
      it 'should return nil if English or Japanese title does not exist' do
        subject = described_class.new({ other_titles: {} }.to_json)

        expect(subject.titles[:en_us]).to be_nil
        expect(subject.titles[:ja_jp]).to be_nil
      end
    end

    describe '#abbreviated_titles' do
      it 'should return an array' do
        expect(subject.abbreviated_titles).to be_an(Array)
      end
      it 'should return all synonyms titles' do
        expect(subject.abbreviated_titles).to eq(['Berserk: The Prototype'])
      end
    end

    describe '#genres' do
      it 'should return an array' do
        expect(subject.genres).to be_an(Array)
      end

      it 'should return all genres' do
        expect(subject.genres).to eq(%w[Action Adventure Demons
                                        Drama Fantasy Horror
                                        Supernatural Military
                                        Psychological Seinen])
      end
    end

    describe '#chapters' do
      it 'should return total chapters' do
        subject = described_class.new({
          chapters: 100
        }.to_json)
        expect(subject.chapters).to eq(100)
      end

      it 'should return nil if no chapters' do
        expect(subject.chapters).to be_nil
      end
    end

    describe '#volumes' do
      it 'should return total volumes' do
        subject = described_class.new({
          volumes: 15
        }.to_json)
        expect(subject.volumes).to eq(15)
      end

      it 'should return nil if no volumes' do
        expect(subject.volumes).to be_nil
      end
    end
  end
end
