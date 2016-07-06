module DataImport
  class MyDramaList
    module Extractor
      class EpisodeList
        include Helpers
        include Enumerable

        attr_reader :dom
        def initialize(html)
          @dom = Nokogiri::HTML(html)
        end

        def episodes
          dom.css('li.episode').map do |row|
            thumb = row.at_css('.cover > .mask')['style'].match(/\((.*)\)/)[1]
            {
              image: original_for(thumb),
              title: row.at_css('.title').content,
              air_date: row.at_css('.air_date').try(:content),
              summary: row.at_css('.summary').at_xpath('text()').try(:content),
              number: row.at_css('.title a')['href'].match(%r{episode/(\d+)})[1]
            }
          end
        end
        delegate :each, to: :episodes
      end
    end
  end
end
