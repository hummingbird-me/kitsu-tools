module DataImport
  class MyAnimeList
    module Extractor
      class Character
        include Enumerable

        attr_reader :dom

        def initialize(html)
          @dom = Nokogiri::HTML(html)
        end

        def name
          # line 473 in guts-character.html
          result = dom.css('#horiznav_nav ~ .normal_header').first.children

          english = result.first.content.strip
          # japanese = result.at_css('small').content.strip
        end

        def image
          # line 319 in guts-character.html
          dom.at_css('#content > table > tr > td:first-child div a img')
             .attr('src')
        end

        def description
          result = dom.css('#content > table >tr > td:nth-child(2)')
                      .children.take_while { |x|
            !x.text.include? 'Voice Actor'
          }.reject { |x|
            x['class'] == 'normal_header' ||
              x['id'] == 'horiznav_nav' ||
              x['itemtype'] == 'http://schema.org/BreadcrumbList'
          }.map(&:to_html).join

          clean_desc(result)
        end

        # synopsis: seriously don't touch this
        # unless you are Nuck (and maybe Toy).
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

        # synopsis: seriously don't touch this unless
        # you are Nuck (and maybe Toy).
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
              node.remove if t[0].length <= 3 && t[1].length <= 20
            elsif /^\s+\*\s+.*/ =~ node.content
              node.remove
            end
          end
          br_to_p(desc.inner_html)
        end

        def to_h
          %i[name image description]
            .map { |k|
              [k, send(k)]
            }.to_h
        end
      end
    end
  end
end
