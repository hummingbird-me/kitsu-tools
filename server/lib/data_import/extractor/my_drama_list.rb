module DataImport
  module Extractor
    class MyDramaList
      attr_reader :details_dom, :cast_dom

      def initialize(details_page, cast_page)
        @details_dom = Nokogiri::HTML(details_page)
        @cast_dom = Nokogiri::HTML(cast_page)
      end

      def title
        details_dom.at_css('h1').content.strip
      end

      def details
        details_dom.css('.show-details .txt-block').map do |row|
          # Grab the header, strip the whitespace and colon
          key = row.at_css('h4').content.strip.sub(/:\z/, '')
          # This little XPath query basically queries for *all* nodes (bare text
          # included) which are not H4 tags, so we get all the content in the
          # row.  Once we grab the content, we strip it of whitespace, nuke the
          # blank entries, and drop the array if it's singular.
          value = row.xpath('node()[not(self::h4)]').map(&:content).map(&:strip)
          value.reject!(&:blank?)
          value = value.one? ? value.first : value
          [key, value]
        end.to_h
      end

      def synopsis
        details_dom.css('.show-synopsis > p').map(&:content).join('\n\n')
      end

      def genres
        details_dom.css('.show-genres > a').map(&:content).map(&:strip)
      end

      def poster_image
        # Extract the image and go fullsize
        original_for details_dom.at_css('.cover img')['src']
      end

      def cast
        cast_dom.css('.cast').map do |row|
          {
            actor: {
              id: row.at_css('.cover')['href'].match(/\/(\d+)/)[1],
              image: original_for(row.at_css('.cover img')['src']),
              name: row.at_css('.name').content.strip
            },
            character: {
              name: row.at_css('.aka').content.strip,
              role: row.at_css('.role').content.strip
            }
          }
        end
      end

      private

      def original_for(src)
        src.sub(/_[a-z0-9]+\./, '_f.')
      end
    end
  end
end
