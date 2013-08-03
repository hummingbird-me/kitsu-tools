require 'open-uri'

class MalImport
  def self.create_series_castings(id)
    anime = Anime.find_by_mal_id id

    noko = Nokogiri::HTML open("http://myanimelist.net/anime/#{id}/a/characters").read
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
          charmap[char[:mal_id]].image = URI(Nokogiri::HTML(open("http://myanimelist.net/character/#{char[:mal_id]}")).css("img")[0].attributes["src"].value)
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
          person.image = URI(Nokogiri::HTML(open("http://myanimelist.net/people/#{person.mal_id}")).css("img")[0].attributes["src"].value)
          person.image = nil if person.image_file_name =~ /na\.gif/
          person.save
        rescue
        end
      end
    end
  end
  
  def self.series_metadata(id)
    begin
      MalImport.create_series_castings(id)
    rescue
    end
    
    noko = Nokogiri::HTML open("http://myanimelist.net/anime/#{id}").read
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
    meta[:cover_image_url] = sidebar.css("img")[0].attribute('src').value
    
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
      dates = sidebar.css('div').select {|x| x.text.include? "Aired:" }[0].text.gsub("Aired:", '').split(" to ").map {|x| x.strip }.map {|x| x == "?" ? nil : DateTime.parse(x).to_date }
      meta[:dates][:from] = dates[0]
      meta[:dates][:to] = dates[1]
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
  
  VALID_XML_CHARS = /^(
      [\x09\x0A\x0D\x20-\x7E] # ASCII
    | [\xC2-\xDF][\x80-\xBF] # non-overlong 2-byte
    | \xE0[\xA0-\xBF][\x80-\xBF] # excluding overlongs
    | [\xE1-\xEC\xEE][\x80-\xBF]{2} # straight 3-byte
    | \xEF[\x80-\xBE]{2} #
    | \xEF\xBF[\x80-\xBD] # excluding U+fffe and U+ffff
    | \xED[\x80-\x9F][\x80-\xBF] # excluding surrogates
    | \xF0[\x90-\xBF][\x80-\xBF]{2} # planes 1-3
    | [\xF1-\xF3][\x80-\xBF]{3} # planes 4-15
    | \xF4[\x80-\x8F][\x80-\xBF]{2} # plane 16
  )*$/nx;

  def self.fetch_watchlist_from_remote(username)
    watchlist = []
    animelist = Hash.from_xml(open("http://myanimelist.net/malappinfo.php?status=all&type=anime&u=#{username}").read.encode('ASCII-8BIT', invalid: :replace, undef: :replace, replace: '').split('').select {|x| x =~ VALID_XML_CHARS }.join.encode('UTF-8'))
    status_map = {
      "1"           => "Currently Watching",
      "watching"    => "Currently Watching",
      "2"           => "Completed",
      "completed"   => "Completed",
      "3"           => "On Hold",
      "onhold"      => "On Hold",
      "4"           => "Dropped",
      "dropped"     => "Dropped",
      "6"           => "Plan to Watch",
      "plantowatch" => "Plan to Watch"
    }
    animelist["myanimelist"]["anime"].each do |indv|
      parsd = {
        mal_id: indv["series_animedb_id"], 
        rating: indv["my_score"],
        episodes_watched: indv["my_watched_episodes"],
        status: status_map[indv["my_status"]],
        last_updated: Time.at(indv["my_last_updated"].to_i),
        notes: indv["my_tags"]
      }
      watchlist.push(parsd) unless Anime.find_by_mal_id(parsd[:mal_id]).nil?
    end
    watchlist
  end
  
  # Private: get all of the reviews from a single given page.
  def self.get_reviews(page)
    return []

    reviews = []
    page.css('div.borderDark').each do |rev|
      if rev.css('div.spaceit.borderLight small').text == "(Anime)"
        anime_id = rev.css('div.spaceit.borderLight a.hoverinfo_trigger')[0].attribute("href").value.scan(/^http:\/\/myanimelist\.net\/anime\/(\d+)\//).flatten[0]
        review = rev.css('div.spaceit.textReadability')[0].children[4..-3].text

        ratings = rev.css('div.spaceit.textReadability table.borderClass tr').map {|x| x.text.split }
        rating = ratings.select {|x| x[0] == "Overall" }[0][1].to_i
        rating_story = ratings.select {|x| x[0] == "Story" }[0][1].to_i rescue nil
        rating_animation = ratings.select {|x| x[0] == "Animation" }[0][1].to_i rescue nil
        rating_sound = ratings.select {|x| x[0] == "Sound" }[0][1].to_i rescue nil
        rating_character = ratings.select {|x| x[0] == "Character" }[0][1].to_i rescue nil
        rating_enjoyment = ratings.select {|x| x[0] == "Enjoyment" }[0][1].to_i rescue nil

        reviews.push({
          mal_id: anime_id, 
          rating: rating, 
          rating_story: rating_story, 
          rating_animation: rating_animation, 
          rating_sound: rating_sound, 
          rating_character: rating_character, 
          rating_enjoyment: rating_enjoyment, 
          content: review
        }) if Anime.exists?(mal_id: anime_id)
      end
    end
    reviews
  end
  

  def self.fetch_reviews_from_remote(username)
    reviews = []
    
    reviewpage = Nokogiri::HTML(open("http://myanimelist.net/profile/#{username}/reviews"), nil, 'utf-8')
    reviews += MalImport.get_reviews(reviewpage)
    page = 0
    while reviewpage.css('a').any? {|t| t.text == "More Reviews" }
      page += 1
      reviewpage = Nokogiri::HTML(open("http://myanimelist.net/profile/#{username}/reviews&p=#{page}"), nil, 'utf-8')
      reviews += MalImport.get_reviews(reviewpage)
    end
    
    reviews
  end
  
  def self.get_watchlist_from_staged_import(staged_import, options={})
    watchlists = []
    animes = {}
    
    Anime.where(mal_id: staged_import["data"][:watchlist].map {|x| x[:mal_id] })
         .each {|a| animes[a.mal_id] = a }
         
    consider = staged_import["data"][:watchlist].sort_by {|x| -x[:last_updated].to_i }
    
    if options[:per]
      page = options[:page].to_i rescue 1
      page = 1 if page < 1
      per  = options[:per].to_i  rescue 100
      total = consider.length
      consider = consider[((page-1)*per)...(page*per)]
    end
    
    consider.each do |w|
      anime = animes[ w[:mal_id].to_i ]
      if anime
        watchlist = Watchlist.where(user_id: staged_import.user, anime_id: anime).first || Watchlist.new(user: staged_import.user, anime: anime)
        
        watchlist.status = w[:status]
        watchlist.episodes_watched = w[:episodes_watched]
        watchlist.updated_at = w[:last_updated]
        watchlist.notes = w[:notes]
        watchlist.imported = true

        rating = nil
        if w[:rating] != '0'
          rating = w[:rating].to_i rescue 5
          rating = rating.to_f / 2
        end
        watchlist.rating = rating
        
        watchlists.push( [anime, watchlist] )
      end
    end
    
    if options[:per]
      watchlists = ([nil] * (per*(page-1))) + watchlists + ([nil] * (total-watchlists.length))
    end

    watchlists
  end
  
  def self.get_reviews_from_staged_import(staged_import)
    reviews = []
    staged_import["data"][:reviews].each do |rev|
      review = Review.new(
        user: staged_import.user, 
        anime: Anime.find_by_mal_id(rev[:mal_id]), 
        content: rev[:content], 
        rating: rev[:rating],
        rating_story: rev[:rating_story],
        rating_animation: rev[:rating_animation],
        rating_sound: rev[:rating_sound],
        rating_character: rev[:rating_character],
        rating_enjoyment: rev[:rating_enjoyment],
        source: "mal_import")
      reviews.push(review) unless review.anime.nil?
    end
    reviews
  end
end
