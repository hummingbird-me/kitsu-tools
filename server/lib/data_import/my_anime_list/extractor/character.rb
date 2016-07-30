module DataImport
  class MyAnimeList
    module Extractor
      class Character
        attr_reader :dom

        def initialize(html)
          @dom = Nokogiri::HTML(html)
        end

        def name

        end

        def description

        end

        def image_url

        end



      end
    end
  end
end
