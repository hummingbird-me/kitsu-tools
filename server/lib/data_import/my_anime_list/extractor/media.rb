class DataImport::MyAnimeList
  module Extractor
    class Media
      attr_reader :data

      def initialize(json)
        @data = JSON.parse(json)
      end

      # classification
      def age_rating

      end

      # episodes
      def episode_count
        data['episodes']
      end

      # duration
      def episode_length
        data['duration']
      end

      # synopsis
      def synopsis
        clean_desc(data['synopsis'])
      end

      # preview
      def youtube_video_id
        data['preview']
      end

      #skipping images for now, will go here
      # and here


      def average_rating
        data['members_score']
      end

      def user_count
        data['members_count']
      end

      def show_type
        data['type'].downcase.to_sym
      end

      def start_date
        data['start_date'].to_date
      end

      def end_date
        data['end_date'].try(:to_date)
      end






      # titles
      def titles
        titles = {
          en_jp: data['title'],
          en_us: data['other_titles']['english'].try(:first),
          ja_jp: data['other_titles']['japanese'].try(:first)
        }
      end

      # really not sure what the fuck this is
      def canonical_title

      end

      # abbreviated titles
      def abbreviated_titles
        data['other_titles']['synonyms']
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
