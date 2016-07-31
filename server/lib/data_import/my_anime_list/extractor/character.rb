module DataImport
  class MyAnimeList
    module Extractor
      class Character
        include Enumerable

        attr_reader :dom, :external_id

        def initialize(html, external_id)
          @dom = Nokogiri::HTML(html)
          @external_id = external_id
        end

        def name
          # dom.css('span[itemprop=name]').last.text.strip
          external_id.split('/').last.gsub('_', ' ')
        end

        def description

          # p dom.css('table tr td').children
          # grab all the normal headers
          # find the one that has text of #{name}
          # get all the children and take the last one
        end

        def image_url
          # use external id to find a href with "/character/#{external_id}/pictures"
          # get the child img src url
          {
            image: dom.at_css("a[href='/character/#{external_id}/pictures']").child.first.last
          }
        end
      end
    end
  end
end
