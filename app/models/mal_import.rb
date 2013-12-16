require 'open-uri'
require 'resource_fetcher'

class MalImport
  def self.create_series_castings(id)
    anime = Anime.find_by_mal_id id

    noko = Nokogiri::HTML ResourceFetcher.new("http://myanimelist.net/anime/#{id}/a/characters").get
    cont = noko.css('h2').select {|x| x.text.include? "Characters & Voice Actors" }[0].parent

    charactersc = []
    staffc = cont.children[-1]
    cont.children.each do |x|
      break if x.name == "br"
      charactersc.push x if x.name == "table"
    end

    staff = []
    staffc.css('tr td:nth-child(2)').each do |sm|
      mal_id = sm.css('a').attribute('href').value.scan(/people\/(\d+)\//).flatten[0]
      name = sm.css('a').text
      role = sm.css('small').text
      staff.push({mal_id: mal_id, name: name, role: role})
    end

    characters = []
    charactersc.each do |chara|
      mal_id = chara.css('tr td:nth-child(2) a').attribute('href').value.scan(/character\/(\d+)\//).flatten[0]
      name = chara.css('tr td:nth-child(2) a').text
      role = chara.css('tr td:nth-child(2) small').text
      vas = []
      chara.css('tr td:nth-child(3) table tr td:nth-child(1)').each do |va|
        if va.text.strip.length > 0
          va_mal_id = va.css('a').attribute('href').value.scan(/people\/(\d+)\//).flatten[0]
          va_name = va.css('a').text
          va_lang = va.css('small').text
          vas.push( {mal_id: va_mal_id, name: va_name, lang: va_lang} )
        end
      end

      characters.push( {mal_id: mal_id, role: role, name: name, voice_actors: vas} )
    end
    
    # Find or create all characters and the corresponding voice actors.
    # Also create the relevant castings if they don't exist.
    charmap = {}
    vamap = {}
    characters.each do |char|
      charmap[char[:mal_id]] = Character.find_by_mal_id(char[:mal_id]) || Character.create(name: char[:name].strip.split(', ').reverse.join(' '), mal_id: char[:mal_id])
      if charmap[char[:mal_id]].image_file_name.nil?
        begin
          charmap[char[:mal_id]].image = URI(Nokogiri::HTML(ResourceFetcher.new("http://myanimelist.net/character/#{char[:mal_id]}").get).css("img")[0].attributes["src"].value)
          charmap[char[:mal_id]].image = nil if charmap[char[:mal_id]].image_file_name =~ /na\.gif/
          charmap[char[:mal_id]].save
        rescue
        end
      end
      
      char[:voice_actors].each do |va|
        vamap[va[:mal_id]] = Person.find_by_mal_id(va[:mal_id]) || Person.create(name: va[:name].strip.split(', ').reverse.join(' '), mal_id: va[:mal_id])
        
        # Now onto the casting creation.
        unless Casting.exists?(anime_id: anime.id, character_id: charmap[char[:mal_id]].id, person_id: vamap[va[:mal_id]].id)
          c = Casting.new
          c.anime_id = anime.id
          c.character = charmap[char[:mal_id]]
          c.person = vamap[va[:mal_id]]
          c.role = va[:lang]
          c.voice_actor = true
          c.save
        end
      end
    end
    
    # Now onto the staff castings.
    staff.each do |mem|
      person = Person.find_by_mal_id(mem[:mal_id]) || Person.create(mal_id: mem[:mal_id], name: mem[:name].strip.split(', ').reverse.join(' '))
      unless Casting.exists?(anime_id: anime.id, person_id: person.id, voice_actor: false)
        c = Casting.new
        c.anime_id = anime.id
        c.person = person
        c.role = mem[:role]
        c.voice_actor = false
        c.save
      end
    end
    
    anime.castings.map {|x| x.person }.uniq.each do |person|
      if person.image_file_name.nil?
        begin
          person.image = URI(Nokogiri::HTML(ResourceFetcher.new("http://myanimelist.net/people/#{person.mal_id}").get).css("img")[0].attributes["src"].value)
          person.image = nil if person.image_file_name =~ /na\.gif/
          person.save
        rescue
        end
      end
    end
  end
  
  def self.series_metadata(id)
    noko = Nokogiri::HTML ResourceFetcher.new("http://myanimelist.net/anime/#{id}").get
    meta = {}

    # Get title and alternate title.
    title = noko.css("h1").children[1].text
    aka   = noko.css(".spaceit_pad").select {|x| x.text.include? "English:" }[0].text.gsub("English: ", "") rescue nil
    meta[:title]           = title
    meta[:english_title]   = (title != aka) ? aka : nil
    
    # Synopsis
    meta[:synopsis] = noko.css("td").select {|x| x.css("h2").text == "Synopsis" }[0].text.gsub("Synopsis", '') rescue nil
    
    sidebar = noko.css('table tr td.borderClass')[0]
    
    # Cover image URL
    meta[:poster_image_url] = sidebar.css("img")[0].attribute('src').value
    
    # Genres
    meta[:genres] = (sidebar.css("div").select {|x| x.text.include? "Genres:" }[0].css("a").map(&:text) rescue []).map {|x| Genre.find_by_name(x) }.compact
    
    # Producers
    meta[:producers] = (sidebar.css("div").select {|x| x.text.include? "Producers:" }[0].css("a").map(&:text) rescue []).map {|x| Producer.find_by_name(x) }.compact
    
    # Age rating
    meta[:age_rating] = sidebar.css("div").select {|x| x.text.include? "Rating:" }[0].children[1].text.strip rescue nil
    
    # Episode count
    meta[:episode_count] = sidebar.css('div').select {|x| x.text.include? "Episodes:" }[0].children[1].text.strip rescue nil
    
    # Episode length
    episode_length = sidebar.css("div").select {|x| x.text.include? "Duration:" }[0].children[1].text.strip rescue nil
    if not episode_length.nil?
      hours = episode_length.scan(/(\d+) hr\./).flatten[0] || 0
      hours = hours.to_i
      mins = episode_length.scan(/(\d+) min\./).flatten[0] || 0
      mins = mins.to_i
      episode_length = 60 * hours + mins
    end
    meta[:episode_length] = episode_length
    
    # Status
    meta[:status] = sidebar.css("div").select {|x| x.text.include? "Status:" }[0].children[1].text.strip rescue nil
    meta[:status] = "Not Yet Aired" if meta[:status] == "Not yet aired"

    # Air dates
    meta[:dates] = {}
    begin
      dates = sidebar.css('div').select {|x| x.text.include? "Aired:" }[0].text.gsub("Aired:", '')
      if dates.include? "to"
        dates = dates.split(" to ").map {|x| x.strip }
        dates = dates.map do |x| 
          if x.strip.match /^\d+$/
            Date.new x.strip.to_i
          else
            x == "?" ? nil : DateTime.parse(x).to_date 
          end
        end
        meta[:dates][:from] = dates[0]
        meta[:dates][:to] = dates[1]
      else
        if dates.strip.match /^\d+$/
          meta[:dates][:from] = Date.new dates.strip.to_i
        else
          meta[:dates][:from] = (dates.strip == "?") ? nil : DateTime.parse(dates).to_date 
        end
      end
    rescue
    end

    # Show type
    begin
      type = sidebar.css('div').select {|x| x.text.include? "Type:" }[0].text.gsub("Type:", '').strip
      if ["TV", "Movie", "OVA", "Special", "ONA", "Music"].include? type
        meta[:show_type] = type
      end
    rescue
    end
    
    meta[:featured_character_mal_ids] = noko.css('table div.picSurround a').map {|x| x.attributes["href"].to_s }.select {|x| x =~ /character\// }.map {|x| x.scan(/character\/(\d+)/) }.flatten.map {|x| x.to_i }
    
    return meta
  end
end
