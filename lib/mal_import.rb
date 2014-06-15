require 'open-uri'

class MALImport
  def initialize (media, id)
    @media = media
    @mal_id = id
    @main_noko = Nokogiri::HTML open("http://myanimelist.net/#{media.to_s}/#{id}", 'User-Agent' => 'iMAL-iOS').read
    char_page = Nokogiri::HTML open("http://myanimelist.net/#{media.to_s}/#{id}/a/characters", 'User-Agent' => 'iMAL-iOS').read
    @char_noko = char_page.css('h2:contains("Characters")')[0].parent
  end
  def staff
    @char_noko.css('a[name="staff"] + h2 + table tr td:nth-child(2)').map do |sm|
      {
        external_id: sm.css('a')[0]['href'].scan(/people\/(\d+)\//).flatten[0].to_i,
        name: sm.css('a').text.split(',').map(&:strip).reverse.join(' '),
        role: sm.css('small').text
      }
    end
  end
  def characters
    featured_chars = @main_noko.css('table div.picSurround a[href*="character/"]').map {|x| x['href'].scan(/character\/(\d+)/) }.flatten.map(&:to_i)

    @char_noko.css('h2:contains("Characters") ~ *').take_while { |x|
      x.name == 'table'
    }.map do |chara|
      external_id = chara.css('td:nth-child(2) > a')[0]['href'].scan(/character\/(\d+)\//).flatten[0].to_i
      {
        external_id: external_id,
        name: chara.css('td:nth-child(2) > a').text.split(',').map(&:strip).reverse.join(' '),
        role: chara.css('td:nth-child(2) small').text,
        featured: featured_chars.include?(external_id),
        voice_actors: chara.css('td:nth-child(3) tr > td:nth-child(1)').map do |va|
          {
            external_id: va.css('a')[0]['href'].scan(/people\/(\d+)\//).flatten[0].to_i,
            name: va.css('a').text.split(',').map(&:strip).reverse.join(' '),
            lang: va.css('small').text
          } if va.children.length > 0
        end.compact
      }
    end
  end
  def metadata
    sidebar = @main_noko.css('td.borderClass')[0]

    meta = {
      external_id: @mal_id,
      title: @main_noko.css('h1').children[1].text,
      english_title: begin sidebar.css('div:contains("English:")')[0].text.gsub("English: ", "") rescue nil end,
      synopsis: begin
        synopsis = @main_noko.css('td td:contains("Synopsis")')[0].text.gsub("Synopsis", '')
        if synopsis.include? "No synopsis has been added"
          nil
        else
          synopsis
        end
      rescue
      end,
      poster_image: URI(sidebar.css("img")[0]['src']),
      genres: begin (sidebar.css('span:contains("Genres:") ~ a').map(&:text) rescue []).compact end,
      type: begin allowed_types.grep(sidebar.css('div:contains("Type:")')[0].text.gsub("Type:", '').strip)[0] rescue nil end,
      status: begin sidebar.css('div:contains("Status:")')[0].children[1].text.strip.gsub(/\w+/){ |w| w.capitalize } rescue nil end
    }

    # Media-specific data
    case @media
    when :manga
      meta.merge!({
        dates: begin sidebar.css('div:contains("Published:")')[0].text.gsub("Published:", '').split("to").map { |s| parse_maldate(s) } rescue nil end,
        authors: begin (sidebar.css('span:contains("Authors:") ~ a').map(&:text) rescue []).compact end,
        volumes: begin sidebar.css('div:contains("Volumes:")')[0].text.gsub("Volumes: ", "") rescue nil end,
        chapters: begin sidebar.css('div:contains("Volumes:")')[0].text.gsub("Volumes: ", "") rescue nil end,
        serialization: begin sidebar.css('div:contains("Serialization:") ~ a')[0].text.gsub("Serialization: ", "") rescue nil end,
      })
    when :anime
      meta.merge!({
        dates: begin sidebar.css('div:contains("Aired:")')[0].text.gsub("Aired:", '').split("to").map { |s| parse_maldate(s) } rescue nil end,
        producers: begin (sidebar.css('span:contains("Producers:") ~ a').map(&:text) rescue []).compact end,
        age_rating: begin sidebar.css('div:contains("Rating:")')[0].children[1].text.strip rescue nil end,
        episode_count: begin sidebar.css('div:contains("Episodes:")')[0].children[1].text.strip.to_i rescue nil end,
        episode_length: parse_duration(begin sidebar.css('div:contains("Duration:")')[0].children[1].text.strip rescue nil end),
      })
    end

    # post processing
    meta[:english_title] = nil if meta[:english_title] == meta[:title]
    return meta
  end
  def to_h
    metadata.merge({
      staff: staff,
      characters: characters
    })
  end

  private
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
