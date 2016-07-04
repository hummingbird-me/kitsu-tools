class DataImport::MyAnimeList
  module Extractor
    class Media
      attr_reader :data

      def initialize(json)
        @data = JSON.parse(json)
      end

      def age_rating
        return unless data['classification']
        rating = data['classification'].split(' - ')

        case rating[0]
        when 'G','TV-Y7' then :G
        when 'PG', 'PG13' then :PG
        when 'R', 'R+' then :R
        when 'Rx' then :R18
        end
      end

      def episode_count
        data['episodes']
      end

      def episode_length
        data['duration']
      end

      def synopsis
        clean_desc(data['synopsis'])
      end

      def youtube_video_id
        data['preview']&.split('/')&.last
      end

      def poster_image
        data['image_url']
      end

      def age_rating_guide
        return unless data['classification']
        rating = data['classification'].split(' - ')

        return "Violence, Profanity" if rating[0] == 'R'
        return rating[1] if rating[1].present?

        # fallback
        case rating[0]
        when 'G' then 'All Ages'
        when 'PG' then 'Children'
        when 'PG13', 'PG-13' then 'Teens 13 or older'
        # when 'R' then 'Violence, Profanity' # this will NEVER happen because of return
        when 'R+' then 'Mild Nudity'
        when 'Rx' then 'Hentai'
        end
      end

      def subtype # will be renamed to this hopefully
        # anime matches [TV special OVA ONA movie music]
        # manga matches [manga novel manhua oneshot doujin]

        case data['type'].downcase
        # anime
        when 'tv' then :TV
        when 'special' then :special
        when 'ova' then :OVA
        when 'ona' then :ONA
        when 'movie' then :movie
        when 'music' then :music
        # manga
        when 'manga' then :manga
        when 'novel' then :novel
        when 'manuha' then :manuha
        when 'oneshot' then :oneshot
        when 'doujin' then :doujin
        end
      end

      def start_date
        data['start_date']&.to_date
      end

      def end_date
        data['end_date']&.to_date
      end

      def titles
        titles = {
          en_jp: data['title'],
          en_us: data['other_titles']['english'].try(:first),
          ja_jp: data['other_titles']['japanese'].try(:first)
        }
      end

      def abbreviated_titles
        data['other_titles']['synonyms']
      end

      # Manga Specific

      def chapters
        data['chapters']
      end

      def volumes
        data['volumes']
      end

      # removed subtype (show_type, manga_type issue)
      # missing status on manga (anime does automagically)
      def to_h
        %i[age_rating episode_count episode_length synopsis youtube_video_id
           poster_image age_rating_guide start_date end_date
           titles abbreviated_titles chapters volumes
        ].map do |k|
          [k, send(k)]
        end.to_h
      end

      def genres
        data['genres']
      end



      # synopsis: seriously don't touch this unless you are Nuck.
      def br_to_p(src)
        src = '<p>' + src.gsub(/<br>\s*<br>/, '</p><p>') + '</p>'
        doc = Nokogiri::HTML.fragment src
        doc.traverse do |x|
          next x.remove if x.name == 'br' && x.previous.nil?
          next x.remove if x.name == 'br' && x.next.nil?
          next x.remove if x.name == 'br' && x.next.name == 'p' && x.previous.name == 'p'
          next x.remove if x.name == 'p' && x.content.blank?
        end
        doc.inner_html.gsub(/[\r\n\t]/, '')
      end

      # synopsis: seriously don't touch this unless you are Nuck.
      def clean_desc(desc)
        desc = Nokogiri::HTML.fragment br_to_p(desc)
        desc.css('.spoiler').each do |x|
          x.name = 'span'
          x.inner_html = x.css('.spoiler_content').inner_html
          x.css('input').remove
        end
        desc.css('.spoiler').wrap('<p></p>')
        desc.xpath('descendant::comment()').remove
        desc.css('b').each { |b| b.replace(b.content) }
        desc.traverse do |node|
          next unless node.text?
          t = node.content.split(/: ?/).map { |x| x.split(' ') }
          if t.length >= 2
            if t[0].length <= 3 && t[1].length <= 20
              node.remove
            end
          else
            node.remove if /^\s+\*\s+.*/ =~ node.content
          end
        end
        desc.inner_html
      end

    end
  end
end
