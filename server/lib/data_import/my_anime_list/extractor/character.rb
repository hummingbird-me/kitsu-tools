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
          # line 475 in guts-character.html
          options = ['Animeography', 'Mangaography', 'Voice Actors']
          dom.css('.normal_header').map do |row|
            next if  options.include?(row.content.strip)

            english = row.children.first.content.strip
            # japanese = row.children.at_css('small').content.strip

            return english
          end
        end

        def description
          # lines 497 - 503 in guts-character.html

          # p dom.css('table tr td').children
          # grab all the normal headers
          # find the one that has text of #{name}
          # get all the children and take the last one
        end

        def image_url
          # line 321 in guts-character.html
          {
            image: dom.at_css("a[href='/character/#{external_id}/#{name.tr(' ', '_')}/pictures'] img").attr('src')
          }
        end
      end
    end
  end
end
