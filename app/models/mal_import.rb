require 'open-uri'

class MalImport
  def self.series_metadata(id)
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
    
    return meta
  end

  def self.fetch_watchlist_from_remote(username)
    watchlist = []
    animelist = Hash.from_xml(open("http://myanimelist.net/malappinfo.php?status=all&type=anime&u=#{username}").read)
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
        last_updated: Time.at(indv["my_last_updated"].to_i)
      }
      watchlist.push(parsd) unless Anime.find_by_mal_id(parsd[:mal_id]).nil?
    end
    watchlist
  end
  
  # Private: get all of the reviews from a single given page.
  def self.get_reviews(page)
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
        watchlist.imported = true

        if watchlist.rating.nil?
          rating = nil
          if w[:rating] != '0'
            rating = w[:rating].to_i rescue 5
            rating = ((((rating - 1) / 9.0) - 0.5) * 2 * 2).round
          end
          watchlist.rating = rating
        end
        
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
