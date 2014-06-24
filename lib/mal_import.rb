require 'open-uri'

class MALImport
  def initialize (media, id)
    @media = media
    @mal_id = id
    @main_noko = Nokogiri::HTML open("http://myanimelist.net/#{media.to_s}/#{id}/", 'User-Agent' => 'iMAL-iOS').read
    char_page = Nokogiri::HTML open("http://myanimelist.net/#{media.to_s}/#{id}/a/characters", 'User-Agent' => 'iMAL-iOS').read
    @char_noko = char_page.css('h2:contains("Characters")')[0].parent
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
    featured_chars = @main_noko.css('table div.picSurround a[href*="character/"]').map {|x| x['href'].scan(/character\/(\d+)/) }.flatten.map(&:to_i)

    case @media
    when :anime
      @char_noko.css('h2:contains("Characters") ~ *').take_while { |x|
        x.name == 'table'
      }.map do |chara|
        external_id = chara.css('td:nth-child(2) > a')[0]['href'].scan(/character\/(\d+)\//).flatten[0].to_i
        {
          external_id: external_id,
          name: nameflip(chara.css('td:nth-child(2) > a').text),
          role: chara.css('td:nth-child(2) small').text,
          featured: featured_chars.include?(external_id),
          voice_actors: chara.css('td:nth-child(3) tr > td:nth-child(1)').map do |va|
            {
              external_id: va.css('a')[0]['href'].scan(/people\/(\d+)\//).flatten[0].to_i,
              name: nameflip(va.css('a').text),
              lang: va.css('small').text
            } if va.children.length > 0
          end.compact
        }
      end
    when :manga
      @char_noko.css('h2:contains("Characters") ~ table').map do |chara|
        external_id = chara.css('td:nth-child(2) > a')[0]['href'].scan(/character\/(\d+)\//).flatten[0].to_i
        {
          external_id: external_id,
          name: nameflip(chara.css('td:nth-child(2) > a').text),
          role: chara.css('td:nth-child(2) small').text,
          featured: featured_chars.include?(external_id)
        }
      end
    end
  end
  def metadata
    meta = {
      external_id: @mal_id,
      title: {
        canonical: @main_noko.css('h1').children[1].text.strip,
        unknown: begin @sidebar.css('div:contains("Synonyms:")')[0].text.gsub("Synonyms: ", "").split(",").map(&:strip) rescue nil end,
        en_us: begin @sidebar.css('div:contains("English:")')[0].text.gsub("English: ", "") rescue nil end,
        ja_jp: begin @sidebar.css('div:contains("Japanese:")')[0].text.gsub("Japanese: ", "") rescue nil end
      }.compact,
      synopsis: begin
        synopsis = @main_noko.css('td td:contains("Synopsis")')[0].text.gsub("Synopsis", '')
        if synopsis.include? "No synopsis has been added"
          nil
        else
          synopsis
        end
      rescue
      end,
      poster_image: URI(@sidebar.css("img")[0]['src']),
      genres: begin (@sidebar.css('span:contains("Genres:") ~ a').map(&:text) rescue []).compact end,
      type: begin allowed_types.grep(@sidebar.css('div:contains("Type:")')[0].text.gsub("Type:", '').strip)[0] rescue nil end,
      status: begin @sidebar.css('div:contains("Status:")')[0].children[1].text.strip.gsub(/\w+/){ |w| w.capitalize } rescue nil end
    }

    # Media-specific data
    case @media
    when :manga
      meta.merge!({
        dates: begin @sidebar.css('div:contains("Published:")')[0].text.gsub("Published:", '').split("to").map { |s| parse_maldate(s) } rescue nil end,
        volumes: begin @sidebar.css('div:contains("Volumes:")')[0].text.gsub("Volumes: ", "").strip.to_i rescue nil end,
        chapters: begin @sidebar.css('div:contains("Chapters:")')[0].text.gsub("Chapters: ", "").strip.to_i rescue nil end,
        serialization: begin @sidebar.css('span:contains("Serialization:") ~ a').map(&:text)[0] rescue nil end,
      })
    when :anime
      meta.merge!({
        dates: begin @sidebar.css('div:contains("Aired:")')[0].text.gsub("Aired:", '').split("to").map { |s| parse_maldate(s) } rescue nil end,
        producers: begin (@sidebar.css('span:contains("Producers:") ~ a').map(&:text) rescue []).compact end,
        age_rating: begin @sidebar.css('div:contains("Rating:")')[0].children[1].text.strip rescue nil end,
        episode_count: begin @sidebar.css('div:contains("Episodes:")')[0].children[1].text.strip.to_i rescue nil end,
        episode_length: parse_duration(begin @sidebar.css('div:contains("Duration:")')[0].children[1].text.strip rescue nil end),
      })
    end

    # post processing
    meta[:title][:en_us] = nil if meta[:title][:en_us] == meta[:title][:canonical]
    return meta
  end
  def to_h
    metadata.merge({
      staff: staff,
      characters: characters
    })
  end

  private
  def nameflip(name)
    name.split(',').map(&:strip).reverse.join(' ')
  end
  def allowed_types
    case @media
    when :anime
      ["TV", "Movie", "OVA", "Special", "ONA", "Music"]
    when :manga
      ["Manga"]
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
end
