module DataImport
  class MyDramaList
    module Extractor
      class CastList
        include Helpers
        include Enumerable

        attr_reader :dom
        def initialize(html)
          @dom = Nokogiri::HTML(html)
        end

        def cast
          dom.css('.cast').map do |row|
            {
              actor: {
                id: row.at_css('.cover')['href'].match(%r{/(\d+)})[1],
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
        delegate :each, to: :cast
      end
    end
  end
end
