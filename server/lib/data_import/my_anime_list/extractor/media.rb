class DataImport::MyAnimeList
  module Extractor
    class Media
      attr_reader :data

      def initialize(json)
        @data = JSON.parse(json)
      end

      def age_rating
        rating = data['classification'].split(' - ')[0]

        case rating
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
        data['preview']
      end

      def poster_image
        data['image_url']
      end

      def average_rating
        data['members_score']
      end

      def user_count
        data['members_count']
      end

      def age_rating_guide
        rating = data['classification'].split(' - ')[0]

        case rating
        when 'G' then 'All Ages'
        when 'PG' then 'Children'
        when 'PG13', 'PG-13' then 'Teens 13 or older'
        when 'R' then 'Violence, Profanity'
        when 'R+' then 'Mild Nudity'
        when 'Rx' then 'Hentai'
        end
      end

      def show_type
        # needs to match one of these, case statement [TV special OVA ONA movie music]
        case data['type'].downcase
        when 'tv' then :TV
        when 'special' then :special
        when 'ova' then :OVA
        when 'ona' then :ONA
        when 'movie' then :movie
        when 'music' then :music
        end
      end

      def start_date
        data['start_date'].to_date
      end

      def end_date
        data['end_date'].try(:to_date)
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
      

      def to_h
        %i[age_rating episode_count episode_length synopsis youtube_video_id
           poster_image average_rating user_count age_rating_guide show_type start_date end_date
           titles abbreviated_titles
        ].map do |k|
          [k, send(k)]
        end.to_h
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
