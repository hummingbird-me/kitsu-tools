class DataImport::MyDramaList
  module Extractor
    class Details
      COUNTRY_CODES = {
        'South Korea' => 'sk',
        'Japan' => 'jp',
        'China' => 'cn',
        'Taiwan' => 'tw',
        'Hong Kong' => 'hk',
        'Thailand' => 'th'
      }.freeze
      LANGUAGE_CODES = {
        'South Korea' => 'ko',
        'Japan' => 'ja',
        'China' => 'zh',
        'Taiwan' => 'zh',
        'Hong Kong' => 'zh',
        'Thailand' => 'th'
      }.freeze
      SHOW_TYPES = {
        'Drama' => :drama,
        'Movie' => :movie,
        'Drama Special' => :special
      }.freeze

      include Helpers

      attr_reader :dom
      def initialize(html)
        @dom = Nokogiri::HTML(html)
      end

      def titles
        main_title = dom.at_css('h1').content.
                         gsub("(#{start_date.try(:year)})", '').strip
        titles = {}
        titles["en_#{country}"] = main_title
        titles["#{language}_#{country}"] = details['Native title']
        titles
      end

      def canonical_title
        "en_#{country}"
      end

      def abbreviated_titles
        (details['Also Known as'] || '').split(';').map(&:strip)
      end

      def synopsis
        dom.css('.show-synopsis > p').map(&:content).join('\n\n')
      end

      def episode_count
        (details['Episodes'] || 1).to_i
      end

      def episode_length
        str = details['Duration']
        parts = str.match(/(?:(?<hr>\d+) hr. )?(?<min>\d+) min./)
        (parts['hr'].to_i * 60) + parts['min'].to_i
      end

      def show_type
        SHOW_TYPES[details['Type']]
      end

      def poster_image
        original_for dom.at_css('.cover img')['src']
      end

      def start_date
        dates[0]
      end

      def end_date
        dates[1]
      end

      def country
        COUNTRY_CODES[details['Country']]
      end

      def to_h
        %i[titles canonical_title abbreviated_titles synopsis episode_count
           episode_length show_type poster_image start_date end_date country
        ].map do |k|
          [k, send(k)]
        end.to_h
      end

      def genres
        dom.css('.show-genres > a').map(&:content).map(&:strip)
      end

      private

      def details
        @details ||= dom.css('.show-details .txt-block').map do |row|
          # Grab the header, strip the whitespace and colon
          key = row.at_css('h4').content.strip.sub(/:\z/, '')
          # This little XPath query basically queries for *all* nodes (bare
          # text included) which are not H4 tags, so we get all the content in
          # the row.  Once we grab the content, we strip it of whitespace,
          # nuke the blank entries, and drop the array if it's singular.
          value = row.xpath('node()[not(self::h4)]').map(&:content).map(&:strip)
          value.reject!(&:blank?)
          value = value.one? ? value.first : value
          [key, value]
        end.to_h
      end

      def dates
        if details.include? 'Release Date'
          [Date.parse(details['Release Date'])]
        elsif details.include? 'Aired'
          details['Aired'].split('to').map { |d| Date.parse(d) }
        else
          []
        end
      end

      def language
        LANGUAGE_CODES[details['Country']]
      end
    end
  end
end
