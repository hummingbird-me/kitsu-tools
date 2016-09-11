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
          # line 473 in guts-character.html
          options = ['Animeography', 'Mangaography', 'Voice Actors']
          dom.css('.normal_header').map do |row|
            next if  options.include?(row.content.strip)

            english = row.children.first.content.strip
            # japanese = row.children.at_css('small').content.strip

            return english
          end
        end

        def image_url
          # line 319 in guts-character.html
          {
            image: dom.at_css("a[href='/character/#{external_id}/#{name.tr(' ', '_')}/pictures'] img").attr('src')
          }
        end

        def description
          dom.css('#content > table >tr > td:nth-child(2)').children.take_while { |x|
            !x.text.include? 'Voice Actor'
          }.reject { |x|
            x['class'] == 'normal_header' || x['id'] == 'horiznav_nav' ||
            x['itemtype'] == 'http://schema.org/BreadcrumbList'
          }.map { |x|
            reg_check = /\A(.+(?=:)|.{0,30})\z/i

            if x.attributes['class'].try(:value) == "spoiler"
              if x.previous.previous.previous.present? && !(x.previous.previous.previous.content =~ reg_check)
                p 'Deleting Spoiler'
                ''
              else
                p 'Keeping Spoiler'
                "<p class='spoiler'>#{x.content.strip}</p>"
              end
            else
              x.content.strip.gsub(/(\n[ ]+)/,' ')
            end
          }.map { |x|
            reg_check = /\A(.+(?=:)|.{0,30})\z/i

            if x.include?("<p class='spoiler'>")
              x
            elsif x.blank? || x.match(/\A(.+(?=:)|.{0,30})\z/i)
              ''
            else
              "<p>#{x}</p>"
            end
          }.compact.reject(&:empty?)
        end
        #
        # # synopsis: seriously don't touch this unless you are Nuck.
        # def br_to_p(src)
        #   src = '<p>' + src.gsub(/<br>\s*<br>/, '</p><p>') + '</p>'
        #   doc = Nokogiri::HTML.fragment src
        #   doc.traverse do |x|
        #     next x.remove if x.name == 'br' && x.previous.nil?
        #     next x.remove if x.name == 'br' && x.next.nil?
        #     next x.remove if x.name == 'br' && x.next.name == 'p' && x.previous.name == 'p'
        #     next x.remove if x.name == 'p' && x.content.blank?
        #   end
        #   doc.inner_html.gsub(/[\r\n\t]/, '')
        # end
        #
        # # synopsis: seriously don't touch this unless you are Nuck.
        # def clean_desc(desc)
        #   desc = Nokogiri::HTML.fragment br_to_p(desc)
        #   desc.css('.spoiler').each do |x|
        #     x.name = 'span'
        #     x.inner_html = x.css('.spoiler_content').inner_html
        #     x.css('input').remove
        #   end
        #   desc.css('.spoiler').wrap('<p></p>')
        #   desc.xpath('descendant::comment()').remove
        #   desc.css('b').each { |b| b.replace(b.content) }
        #   desc.traverse do |node|
        #     next unless node.text?
        #     t = node.content.split(/: ?/).map { |x| x.split(' ') }
        #     if t.length >= 2
        #       if t[0].length <= 3 && t[1].length <= 20
        #         node.remove
        #       end
        #     else
        #       node.remove if /^\s+\*\s+.*/ =~ node.content
        #     end
        #   end
        #   desc.inner_html
        # end
      end
    end
  end
end
