require 'rails_helper'

RSpec.describe ListImport::MyAnimeList::Row do
  def create_mapping(media)
    fail 'Media must be saved' unless media.persisted?
    prefix = media.class.name.underscore
    fake_id = rand(1..50_000)
    create(:mapping, media: media, external_site: 'myanimelist',
                                   external_id: "#{prefix}/#{fake_id}")
  end

  context 'with an invalid node name' do
    it 'should raise an error' do
      expect {
        xml = Nokogiri::XML.fragment('<test></test>').at_css('test')
        described_class.new(xml)
      }.to raise_error(/invalid type/i)
    end
  end

  context 'with anime' do
    let(:anime) { create(:anime, episode_count: rand(6..50)) }

    def wrap_row(xml)
      Nokogiri::XML.fragment("<anime>#{xml}</anime>").at_css('anime')
    end

    describe '#type' do
      it 'should return Anime class' do
        row = described_class.new(wrap_row(''))
        expect(row.type).to eq(Anime)
      end
    end

    describe '#media' do
      context 'with a specific Mapping' do
        let(:mapping) { create_mapping(anime) }
        let(:xml) { wrap_row <<~EOF }
          <series_animedb_id>
            #{mapping.external_id.split('/').last}
          </series_animedb_id>
          <series_title>#{anime.canonical_title}</series_title>
          <series_type>#{anime.show_type}</series_type>
          <series_episodes>#{anime.episode_count}</series_episodes>
        EOF
        it 'should return the Anime instance from the Mapping' do
          row = described_class.new(xml)
          expect(Mapping).to receive(:lookup)
            .with('myanimelist', mapping.external_id)
            .and_return(anime)
          expect(row.media).to eq(anime)
        end
      end
      context 'without a specific Mapping' do
        let(:xml) { wrap_row <<~EOF }
          <series_animedb_id>#{rand(1..50_000)}</series_animedb_id>
          <series_title>#{anime.canonical_title}</series_title>
          <series_type>#{anime.show_type}</series_type>
          <series_episodes>#{anime.episode_count}</series_episodes>
        EOF
        it 'should guess the Anime instance using Mapping.guess' do
          row = described_class.new(xml)
          expect(Mapping).to receive(:guess).and_return(anime)
          expect(row.media).to eq(anime)
        end
      end
    end

    describe '#media_info' do
      let(:xml) { wrap_row <<~EOF }
        <series_animedb_id>#{anime.id}</series_animedb_id>
        <series_title><![CDATA[#{anime.canonical_title}]]></series_title>
        <series_type>#{anime.show_type}</series_type>
        <series_episodes>#{anime.episode_count}</series_episodes>
      EOF
      subject { described_class.new(xml) }
      it 'should return the id from series_animedb_id' do
        expect(subject.media_info[:id]).to eq(anime.id)
      end
      it 'should return the title from series_itlte' do
        expect(subject.media_info[:title]).to eq(anime.canonical_title)
      end
      it 'should return the show type from series_type' do
        expect(subject.media_info[:show_type]).to eq(anime.show_type)
      end
      it 'should return the episode count from series_episdes' do
        expect(subject.media_info[:episode_count]).to eq(anime.episode_count)
      end
    end

    describe '#status' do
      context 'with a textual my_status' do
        context 'of "Currently Watching"' do
          it 'should return :current' do
            xml = wrap_row '<my_status>Currently Watching</my_status>'
            row = described_class.new(xml)
            expect(row.status).to eq(:current)
          end
        end
        context 'of "Plan to Watch"' do
          it 'should return :planned' do
            xml = wrap_row '<my_status>Plan to Watch</my_status>'
            row = described_class.new(xml)
            expect(row.status).to eq(:planned)
          end
        end
        context 'of "Completed"' do
          it 'should return :completed' do
            xml = wrap_row '<my_status>Completed</my_status>'
            row = described_class.new(xml)
            expect(row.status).to eq(:completed)
          end
        end
        context 'of "On Hold"' do
          it 'should return :on_hold' do
            xml = wrap_row '<my_status>On Hold</my_status>'
            row = described_class.new(xml)
            expect(row.status).to eq(:on_hold)
          end
        end
        context 'of "On-Hold"' do
          it 'should return :on_hold' do
            xml = wrap_row '<my_status>On-Hold</my_status>'
            row = described_class.new(xml)
            expect(row.status).to eq(:on_hold)
          end
        end
        context 'of "Dropped"' do
          it 'should return :dropped' do
            xml = wrap_row '<my_status>Dropped</my_status>'
            row = described_class.new(xml)
            expect(row.status).to eq(:dropped)
          end
        end
      end
      context 'with a numeric my_status' do
        context 'of 1' do
          it 'should return :current' do
            xml = wrap_row '<my_status>1</my_status>'
            row = described_class.new(xml)
            expect(row.status).to eq(:current)
          end
        end
        context 'of 2' do
          it 'should return :completed' do
            xml = wrap_row '<my_status>2</my_status>'
            row = described_class.new(xml)
            expect(row.status).to eq(:completed)
          end
        end
        context 'of 3' do
          it 'should return :on_hold' do
            xml = wrap_row '<my_status>3</my_status>'
            row = described_class.new(xml)
            expect(row.status).to eq(:on_hold)
          end
        end
        context 'of 4' do
          it 'should return :dropped' do
            xml = wrap_row '<my_status>4</my_status>'
            row = described_class.new(xml)
            expect(row.status).to eq(:dropped)
          end
        end
        context 'of 5' do
          it 'should return nil' do
            xml = wrap_row '<my_status>5</my_status>'
            row = described_class.new(xml)
            expect(row.status).to be_nil
          end
        end
        context 'of 6' do
          it 'should return :planned' do
            xml = wrap_row '<my_status>6</my_status>'
            row = described_class.new(xml)
            expect(row.status).to eq(:planned)
          end
        end
      end
    end

    describe '#progress' do
      it 'should return the value in my_watched_episodes' do
        xml = wrap_row '<my_watched_episodes>5</my_watched_episodes>'
        row = described_class.new(xml)
        expect(row.progress).to eq(5)
      end
    end

    describe '#rating' do
      it 'should return half the value in my_score' do
        xml = wrap_row '<my_score>5</my_score>'
        row = described_class.new(xml)
        expect(row.rating).to eq(2.5)
      end
    end

    describe '#reconsume_count' do
      it 'should return the value in my_times_watched' do
        xml = wrap_row '<my_times_watched>3</my_times_watched>'
        row = described_class.new(xml)
        expect(row.reconsume_count).to eq(3)
      end
    end

    describe '#notes' do
      context 'when my_tags is blank' do
        it 'should return the value in my_comments' do
          xml = wrap_row <<~EOF
            <my_comments><![CDATA[Test]]></my_comments>
            <my_tags><![CDATA[]]></my_tags>
          EOF
          row = described_class.new(xml)
          expect(row.notes).to eq('Test')
        end
      end
      context 'when my_comments is blank' do
        it 'should return the value in my_tags' do
          xml = wrap_row <<~EOF
            <my_comments><![CDATA[]]></my_comments>
            <my_tags><![CDATA[Ohai]]></my_tags>
          EOF
          row = described_class.new(xml)
          expect(row.notes).to eq('Ohai')
        end
      end
      context 'when my_comments and my_tags are both blank' do
        it 'should return an empty string' do
          xml = wrap_row <<~EOF
            <my_comments><![CDATA[]]></my_comments>
            <my_tags><![CDATA[]]></my_tags>
          EOF
          row = described_class.new(xml)
          expect(row.notes).to be_blank
        end
      end
      context 'when my_comments and my_tags are both present' do
        it 'should return both, separated by a semicolon' do
          xml = wrap_row <<~EOF
            <my_comments><![CDATA[Oha]]></my_comments>
            <my_tags><![CDATA[you]]></my_tags>
          EOF
          row = described_class.new(xml)
          expect(row.notes).to eq('Oha;you')
        end
      end
    end

    describe '#volumes' do
      it "should return nil because MyAnimeList doesn't have anime volumes" do
        row = described_class.new(wrap_row(''))
        expect(row.volumes).to be_nil
      end
    end

    describe '#start_date' do
      context 'with my_start_date being empty' do
        it 'should return nil' do
          xml = wrap_row '<my_start_date></my_start_date>'
          row = described_class.new(xml)
          expect(row.start_date).to be_nil
        end
      end
      context 'with an invalid date in my_start_date' do
        it 'should return nil' do
          xml = wrap_row '<my_start_date>fuckmyanimelist</my_start_date>'
          row = described_class.new(xml)
          expect(row.start_date).to be_nil
        end
      end
      context 'with a valid ISO 8601 date in my_start_date' do
        it 'should return a date object' do
          xml = wrap_row '<my_start_date>1993-10-11</my_start_date>'
          row = described_class.new(xml)
          expect(row.start_date).to eq(Date.new(1993, 10, 11))
        end
      end
    end

    describe '#finish_date' do
      context 'with my_finish_date being empty' do
        it 'should return nil' do
          xml = wrap_row '<my_finish_date></my_finish_date>'
          row = described_class.new(xml)
          expect(row.finish_date).to be_nil
        end
      end
      context 'with an invalid date in my_finish_date' do
        it 'should return nil' do
          xml = wrap_row '<my_finish_date>fuckmyanimelist</my_finish_date>'
          row = described_class.new(xml)
          expect(row.finish_date).to be_nil
        end
      end
      context 'with a valid ISO 8601 date in my_finish_date' do
        it 'should return a date object' do
          xml = wrap_row '<my_finish_date>1993-10-11</my_finish_date>'
          row = described_class.new(xml)
          expect(row.finish_date).to eq(Date.new(1993, 10, 11))
        end
      end
    end
  end

  context 'with manga' do
    let(:manga) { create(:manga, chapter_count: rand(1..50)) }

    def wrap_row(xml)
      Nokogiri::XML.fragment("<manga>#{xml}</manga>").at_css('manga')
    end

    describe '#type' do
      it 'should return Manga class' do
        row = described_class.new(wrap_row(''))
        expect(row.type).to eq(Manga)
      end
    end

    describe '#media' do
      context 'with a specific Mapping' do
        let(:mapping) { create_mapping(manga) }
        let(:xml) { wrap_row <<~EOF }
          <manga_mediadb_id>
            #{mapping.external_id.split('/').last}
          </manga_mediadb_id>
          <manga_title>#{manga.canonical_title}</manga_title>
          <manga_chapters>#{manga.chapter_count}</manga_chapters>
        EOF
        it 'should return the Manga instance from the Mapping' do
          row = described_class.new(xml)
          expect(Mapping).to receive(:lookup)
            .with('myanimelist', mapping.external_id)
            .and_return(manga)
          expect(row.media).to eq(manga)
        end
      end
      context 'without a specific Mapping' do
        let(:xml) { wrap_row <<~EOF }
          <manga_mediadb_id>#{rand(1..50_000)}</manga_mediadb_id>
          <manga_title>#{manga.canonical_title}</manga_title>
          <manga_chapters>#{manga.chapter_count}</manga_chapters>
        EOF
        it 'should guess the Manga instance using Mapping.guess' do
          row = described_class.new(xml)
          expect(Mapping).to receive(:guess).and_return(manga)
          expect(row.media).to eq(manga)
        end
      end
    end


    describe '#media_info' do
      let(:xml) { wrap_row <<~EOF }
        <manga_mediadb_id>#{manga.id}</manga_mediadb_id>
        <manga_title><![CDATA[#{manga.canonical_title}]]></manga_title>
        <manga_chapters>#{manga.chapter_count}</manga_chapters>
      EOF
      subject { described_class.new(xml) }
      it 'should return the id from manga_mediadb_id' do
        expect(subject.media_info[:id]).to eq(manga.id)
      end
      it 'should return te title from manga_title' do
        expect(subject.media_info[:title]).to eq(manga.canonical_title)
      end
      it 'should return the chapter count from manga_chapters' do
        expect(subject.media_info[:chapter_count]).to eq(manga.chapter_count)
      end
    end

    describe '#status' do
      context 'with a textual my_status' do
        context 'of "Currently Reading"' do
          it 'should return :current' do
            xml = wrap_row '<my_status>Currently Reading</my_status>'
            row = described_class.new(xml)
            expect(row.status).to eq(:current)
          end
        end
        context 'of "Plan to Read"' do
          it 'should return :planned' do
            xml = wrap_row '<my_status>Plan to Read</my_status>'
            row = described_class.new(xml)
            expect(row.status).to eq(:planned)
          end
        end
        context 'of "Completed"' do
          it 'should return :planned' do
            xml = wrap_row '<my_status>Completed</my_status>'
            row = described_class.new(xml)
            expect(row.status).to eq(:completed)
          end
        end
        context 'of "On Hold"' do
          it 'should return :on_hold' do
            xml = wrap_row '<my_status>On Hold</my_status>'
            row = described_class.new(xml)
            expect(row.status).to eq(:on_hold)
          end
        end
        context 'of "On-Hold"' do
          it 'should return :on_hold' do
            xml = wrap_row '<my_status>On-Hold</my_status>'
            row = described_class.new(xml)
            expect(row.status).to eq(:on_hold)
          end
        end
        context 'of "Dropped"' do
          it 'should return :dropped' do
            xml = wrap_row '<my_status>Dropped</my_status>'
            row = described_class.new(xml)
            expect(row.status).to eq(:dropped)
          end
        end
      end
      context 'with a numeric my_status' do
        context 'of 1' do
          it 'should return :current' do
            xml = wrap_row '<my_status>1</my_status>'
            row = described_class.new(xml)
            expect(row.status).to eq(:current)
          end
        end
        context 'of 2' do
          it 'should return :completed' do
            xml = wrap_row '<my_status>2</my_status>'
            row = described_class.new(xml)
            expect(row.status).to eq(:completed)
          end
        end
        context 'of 3' do
          it 'should return :on_hold' do
            xml = wrap_row '<my_status>3</my_status>'
            row = described_class.new(xml)
            expect(row.status).to eq(:on_hold)
          end
        end
        context 'of 4' do
          it 'should return :dropped' do
            xml = wrap_row '<my_status>4</my_status>'
            row = described_class.new(xml)
            expect(row.status).to eq(:dropped)
          end
        end
        context 'of 5' do
          it 'should return nil' do
            xml = wrap_row '<my_status>5</my_status>'
            row = described_class.new(xml)
            expect(row.status).to be_nil
          end
        end
        context 'of 6' do
          it 'should return :planned' do
            xml = wrap_row '<my_status>6</my_status>'
            row = described_class.new(xml)
            expect(row.status).to eq(:planned)
          end
        end
      end
    end

    describe '#progress' do
      it 'should return the value in my_read_chapters' do
        xml = wrap_row '<my_read_chapters>5</my_read_chapters>'
        row = described_class.new(xml)
        expect(row.progress).to eq(5)
      end
    end

    describe '#rating' do
      it 'should return half the value in my_score' do
        xml = wrap_row '<my_score>5</my_score>'
        row = described_class.new(xml)
        expect(row.rating).to eq(2.5)
      end
    end

    describe '#reconsume_count' do
      it 'should return the value in my_times_read' do
        xml = wrap_row '<my_times_read>3</my_times_read>'
        row = described_class.new(xml)
        expect(row.reconsume_count).to eq(3)
      end
    end

    describe '#notes' do
      context 'when my_tags is blank' do
        it 'should return the value in my_comments' do
          xml = wrap_row <<~EOF
            <my_comments><![CDATA[Test]]></my_comments>
            <my_tags><![CDATA[]]></my_tags>
          EOF
          row = described_class.new(xml)
          expect(row.notes).to eq('Test')
        end
      end
      context 'when my_comments is blank' do
        it 'should return the value in my_tags' do
          xml = wrap_row <<~EOF
            <my_comments><![CDATA[]]></my_comments>
            <my_tags><![CDATA[Ohai]]></my_tags>
          EOF
          row = described_class.new(xml)
          expect(row.notes).to eq('Ohai')
        end
      end
      context 'when my_comments and my_tags are both blank' do
        it 'should return an empty string' do
          xml = wrap_row <<~EOF
            <my_comments><![CDATA[]]></my_comments>
            <my_tags><![CDATA[]]></my_tags>
          EOF
          row = described_class.new(xml)
          expect(row.notes).to be_blank
        end
      end
      context 'when my_comments and my_tags are both present' do
        it 'should return both, separated by a semicolon' do
          xml = wrap_row <<~EOF
            <my_comments><![CDATA[Oha]]></my_comments>
            <my_tags><![CDATA[you]]></my_tags>
          EOF
          row = described_class.new(xml)
          expect(row.notes).to eq('Oha;you')
        end
      end
    end

    describe '#volumes' do
      it "should return nil because MyAnimeList doesn't have anime volumes" do
        row = described_class.new(wrap_row(''))
        expect(row.volumes).to be_nil
      end
    end

    describe '#start_date' do
      context 'with my_start_date being empty' do
        it 'should return nil' do
          xml = wrap_row '<my_start_date></my_start_date>'
          row = described_class.new(xml)
          expect(row.start_date).to be_nil
        end
      end
      context 'with an invalid date in my_start_date' do
        it 'should return nil' do
          xml = wrap_row '<my_start_date>fuckmyanimelist</my_start_date>'
          row = described_class.new(xml)
          expect(row.start_date).to be_nil
        end
      end
      context 'with a valid ISO 8601 date in my_start_date' do
        it 'should return a date object' do
          xml = wrap_row '<my_start_date>1993-10-11</my_start_date>'
          row = described_class.new(xml)
          expect(row.start_date).to eq(Date.new(1993, 10, 11))
        end
      end
    end

    describe '#finish_date' do
      context 'with my_finish_date being empty' do
        it 'should return nil' do
          xml = wrap_row '<my_finish_date></my_finish_date>'
          row = described_class.new(xml)
          expect(row.finish_date).to be_nil
        end
      end
      context 'with an invalid date in my_finish_date' do
        it 'should return nil' do
          xml = wrap_row '<my_finish_date>fuckmyanimelist</my_finish_date>'
          row = described_class.new(xml)
          expect(row.finish_date).to be_nil
        end
      end
      context 'with a valid ISO 8601 date in my_finish_date' do
        it 'should return a date object' do
          xml = wrap_row '<my_finish_date>1993-10-11</my_finish_date>'
          row = described_class.new(xml)
          expect(row.finish_date).to eq(Date.new(1993, 10, 11))
        end
      end
    end
  end
end
