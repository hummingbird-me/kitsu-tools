require 'open-uri'

class MALImport
  def get(path)
    Nokogiri::HTML open("http://myanimelist.net#{path}", 'User-Agent' => 'iMAL-iOS').read
  end

  def get_character(id)
    description = get("/character/#{id}").css('#content > table >tr > td:nth-child(2)').children.take_while { |x|
      !x.text.include? 'Voice Actor'
    }.reject { |x|
      x['class'] == 'normal_header' || x['id'] == 'horiznav_nav' ||
        x['itemtype'] == 'http://schema.org/BreadcrumbList'
    }.map(&:to_html).join

    # TODO: move all the character data grabbing into here
    { description: description }
  end

  def initialize (media, id, depth = :deep)
    @shallow = (depth == :shallow)
    @media = media
    @mal_id = id
    @main_noko = get "/#{media.to_s}/#{id}/"
    unless @shallow
      char_page = get "/#{media.to_s}/#{id}/a/characters"
      @char_noko = char_page.css('h2:contains("Characters")')[0].parent
    end
    @sidebar = @main_noko.css('td.borderClass')[0]
  end

  def staff
    case @media
    when :anime
      @char_noko.css('a[name="staff"] + h2 + table tr td:nth-child(2)').map do |sm|
        {
          external_id: sm.css('a')[0]['href'].scan(/people\/(\d+)\//).flatten[0].to_i,
          name: nameflip(sm.css('a').text),
          role: sm.css('small').text
        }
      end
    when :manga
      @sidebar.css('span:contains("Authors:") ~ a').map do |author|
        {
          external_id: author['href'].scan(/people\/(\d+)\//).flatten[0].to_i,
          name: nameflip(author.text.strip),
          role: author.next.text.scan(/\(([^()]+)\)/).flatten[0].strip
        }
      end
    end
  end
  def characters
    featured_chars = @main_noko.css('table div.picSurround a[href*="character/"]').map {|x|
      x['href'].scan(/character\/(\d+)/)
    }.flatten.map(&:to_i)

    case @media
    when :anime
      @char_noko.css('h2:contains("Characters") ~ *').take_while { |x|
        x.name == 'table'
      }.map do |chara|
        external_id = chara.css('td:nth-child(2) > a')[0]['href'].scan(/character\/(\d+)\//).flatten[0].to_i
        character = get_character(external_id)
        {
          external_id: external_id,
          name: nameflip(chara.css('td:nth-child(2) > a').text),
          image: character_image(chara.css("img")[0]['src']),
          role: chara.css('td:nth-child(2) small').text,
          description: clean_desc(character[:description]),
          featured: featured_chars.include?(external_id),
          voice_actors: chara.css('td:nth-child(3) tr > td:nth-child(1)').map do |va|
            {
              external_id: va.css('a')[0]['href'].scan(/people\/(\d+)\//).flatten[0].to_i,
              image: person_image(va.parent.css("img")[0]['src']),
              name: nameflip(va.css('a').text),
              lang: va.css('small').text
            } if va.children.length > 0
          end.compact
        }
      end
    when :manga
      @char_noko.css('h2:contains("Characters") ~ table').map do |chara|
        external_id = chara.css('td:nth-child(2) > a')[0]['href'].scan(/character\/(\d+)\//).flatten[0].to_i
        character = get_character(external_id)
        {
          external_id: external_id,
          name: nameflip(chara.css('td:nth-child(2) > a').text),
          image: character_image(chara.css("img")[0]['src']),
          role: chara.css('td:nth-child(2) small').text,
          description: clean_desc(character[:description]),
          featured: featured_chars.include?(external_id)
        }
      end
    end
  end
  def metadata
    meta = {
      external_id: @mal_id,
      title: {
        canonical: @main_noko.css('h1').children[0].text.strip,
        unknown: begin @sidebar.css('div:contains("Synonyms:")')[0].text.gsub("Synonyms: ", "").split(",").map(&:strip) rescue nil end,
        en_us: begin @sidebar.css('div:contains("English:")')[0].text.gsub("English: ", "").strip rescue nil end,
        ja_jp: begin @sidebar.css('div:contains("Japanese:")')[0].text.gsub("Japanese: ", "").strip rescue nil end
      }.compact,
      synopsis: begin
        synopsis = @main_noko.css('td td:contains("Synopsis")')[0].text.gsub("EditSynopsis", '').split("EditBackground")[0].split("googletag.cmd.push")[0]
        if synopsis.include? "No synopsis"
          nil
        else
          synopsis
        end
      rescue
      end,
      poster_image: poster_image(@sidebar.css("img")[0]['src']),
      type: begin allowed_types.grep(@sidebar.css('div:contains("Type:")')[0].text.gsub("Type:", '').strip)[0] rescue nil end,
      status: begin @sidebar.css('div:contains("Status:")')[-1].text.gsub(/Status:(?:\\n)?\s/, "").strip.gsub(/\w+/){ |w| w.capitalize } rescue nil end,
      genres: begin (@sidebar.css('span:contains("Genres:") ~ a').map(&:text) rescue []).compact end
    }

    # Media-specific data
    case @media
    when :manga
      meta.merge!({
        dates: begin @sidebar.css('div:contains("Published:")')[0].text.gsub("Published:", '').split("to").map { |s| parse_maldate(s) } rescue nil end,
        volume_count: begin @sidebar.css('div:contains("Volumes:")')[0].text.gsub("Volumes: ", "").strip.to_i rescue nil end,
        chapter_count: begin @sidebar.css('div:contains("Chapters:")')[0].text.gsub("Chapters: ", "").strip.to_i rescue nil end,
        serialization: begin @sidebar.css('span:contains("Serialization:") ~ a').map(&:text)[0] rescue nil end
      })
    when :anime
      age_rating = begin @sidebar.css('div:contains("Rating:")')[0].text.gsub("Rating:\n ", "").strip rescue nil end
      age_rating = convert_age_rating(age_rating)
      meta.merge!({
        dates: begin @sidebar.css('div:contains("Aired:")')[0].text.gsub("Aired:", '').split("to").map { |s| parse_maldate(s) } rescue nil end,
        producers: begin (@sidebar.css('span:contains("Producers:") ~ a').map(&:text) rescue []).compact end,
        age_rating: age_rating[0],
        age_rating_guide: age_rating[1],
        episode_count: begin @sidebar.css('div:contains("Episodes:")')[0].text.gsub("Episodes:\n ", "").strip.to_i rescue nil end,
        episode_length: parse_duration(begin @sidebar.css('div:contains("Duration:")')[0].text.gsub("Duration: ", "").strip rescue nil end)
      })
    end

    # post processing
    meta[:title][:en_us] = nil if meta[:title][:en_us] == meta[:title][:canonical]
    return meta
  end
  def to_h
    if @shallow
      metadata.merge({ staff: [], characters: [] })
    else
      metadata.merge({
        staff: staff,
        characters: characters
      })
    end
  end

  private
  def character_image(img)
    img = img.gsub("t.jpg", ".jpg")
    URI(img) unless img.include?("questionmark")
  end
  def person_image(img)
    img = img.gsub("v.jpg", ".jpg")
    URI(img) unless img.include?("questionmark")
  end
  def poster_image(img)
    img = img.gsub(".jpg", "l.jpg")
    URI(img) unless img.include?("na_series")
  end
  def convert_age_rating(rating)
    {
      ""                                => [nil,    nil],
      "None"                            => [nil,    nil],
      "PG-13 - Teens 13 or older"       => ["PG13", "Teens 13 or older"],
      "R - 17+ (violence & profanity)"  => ["R17+", "Violence, Profanity"],
      "R+ - Mild Nudity"                => ["R17+", "Mild Nudity"],
      "PG - Children"                   => ["PG",   "Children"],
      "Rx - Hentai"                     => ["R18+", "Hentai"],
      "G - All Ages"                    => ["G",    "All Ages"],
      "PG-13"                           => ["PG13", "Teens 13 or older"],
      "R+"                              => ["R17+", "Mild Nudity"],
      "PG13"                            => ["PG13", "Teens 13 or older"],
      "G"                               => ["G",    "All Ages"],
      "PG"                              => ["PG",   "Children"]
    }[rating] || [rating, nil]
  end
  def nameflip(name)
    name.split(',').map(&:strip).reverse.join(' ')
  end
  def allowed_types
    case @media
    when :anime
      ["TV", "Movie", "OVA", "Special", "ONA", "Music"]
    when :manga
      ["Manga", "Novel", "One Shot", "Doujin", "Manwha", "Manhua", "OEL"]
    end
  end
  def parse_duration(dur)
    unless dur.nil?
      hours = dur.scan(/(\d+) hr\./).flatten[0].to_i || 0
      mins = dur.scan(/(\d+) min\./).flatten[0].to_i || 0
      60 * hours + mins
    end
  end
  def parse_maldate(maldate)
    d = maldate.strip
    if d.match(/^\d{4}$/) # year
      Date.new d.to_i
    else # date
      d == "?" ? nil : DateTime.parse(d).to_date
    end
  end
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
