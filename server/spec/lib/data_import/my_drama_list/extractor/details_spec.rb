require 'rails_helper'

RSpec.describe DataImport::MyDramaList::Extractor::Details do
  let(:html) { fixture('my_drama_list/karate-robo-zaborgar.html') }
  subject { described_class.new(html) }

  describe '#titles' do
    it 'should return the primary english title of the media' do
      expect(subject.titles['en_jp']).to eq('Karate-Robo Zaborgar')
    end
    it 'should return the native title' do
      expect(subject.titles['ja_jp']).to eq('電人ザボーガー')
    end
  end

  describe '#canonical_title' do
    it 'should link to the primary english title of the media' do
      expect(subject.canonical_title).to eq('en_jp')
    end
  end

  describe '#abbreviated_titles' do
    it 'should return an array' do
      expect(subject.abbreviated_titles).to be_an(Array)
    end
    it 'should return all alternate titles' do
      expect(subject.abbreviated_titles).to eq(['Denjin Zabōgā'])
    end
  end

  describe '#synopsis' do
    it 'should return the plaintext synopsis' do
      expected_synopsis = <<-EOF.strip_heredoc.gsub(/\s+/, ' ').strip
        An evil criminal organisation called Sigma kidnap prominment business
        leaders to harvest their DNA and only Karate-Robo Zaborgar can save them
      EOF
      expect(subject.synopsis).to eq(expected_synopsis)
    end
  end

  describe '#episode_count' do
    context 'for a tv series' do
      subject {
        described_class.new(<<-EOF.strip_heredoc)
          <html><body><div class="show-details"><ul>
            <li class="txt-block"><h4 class="inline">Episodes:</h4> 16</li>
          </ul></div></body></html>
        EOF
      }
      it 'should return the number of episodes' do
        expect(subject.episode_count).to eq(16)
      end
    end
    context 'for a movie' do
      it 'should return 1' do
        expect(subject.episode_count).to eq(1)
      end
    end
  end

  context '#episode_length' do
    it 'should return the runtime of a single unit in minutes' do
      expect(subject.episode_length).to eq(114)
    end
  end

  context '#show_type' do
    it 'should return a Symbol' do
      expect(subject.show_type).to be_a(Symbol)
    end
    it 'should return the type' do
      expect(subject.show_type).to eq(:movie)
    end
  end

  describe '#poster_image' do
    it 'should return the fullsize poster' do
      expect(subject.poster_image).to include('158866959117997028_2835ca55_f.jpg')
    end
  end

  describe '#start_date' do
    it 'should return a Date object' do
      expect(subject.start_date).to be_a(Date)
    end
    context 'for a movie' do
      it 'should return the date the movie was released on' do
        expect(subject.start_date).to eq(Date.new(2011, 10, 15))
      end
    end
    context 'for a drama series' do
      subject {
        described_class.new(<<-EOF.strip_heredoc)
          <html><body><div class="show-details"><ul><li class="txt-block">
            <h4 class="inline">Aired:</h4> Jan 22, 2016 to Mar 12, 2016
          </li></ul></div></body></html>
        EOF
      }
      it 'should return the date the first episode aired' do
        expect(subject.start_date).to eq(Date.new(2016, 1, 22))
      end
    end
  end

  describe '#end_date' do
    context 'for a movie' do
      it 'should return nil' do
        expect(subject.end_date).to be_nil
      end
    end
    context 'for a drama series' do
      subject {
        described_class.new(<<-EOF.strip_heredoc)
          <html><body><div class="show-details"><ul><li class="txt-block">
            <h4 class="inline">Aired:</h4> Jan 22, 2016 to Mar 12, 2016
          </li></ul></div></body></html>
        EOF
      }
      it 'should return the date the series ended' do
        expect(subject.end_date).to eq(Date.new(2016, 3, 12))
      end
    end
  end

  describe '#country' do
    it 'should return a two-letter code representing the country' do
      expect(subject.country).to eq('jp')
    end
  end

  context '#genres' do
    it 'should return an array of genre strings' do
      expect(subject.genres).to eq(%w[Action Sci-Fi Tokusatsu])
    end
  end

  describe '#to_h' do
    it 'should return a Hash' do
      expect(subject.to_h).to be_a(Hash)
    end
  end
end
