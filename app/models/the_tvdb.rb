class TheTvdb
  API_KEY = "21F012C4F48D4288"

  # Returns the path of a mirror.
  def self.get_mirror
    #m = Hash.from_xml(open("http://thetvdb.com/api/#{API_KEY}/mirrors.xml").read)
    #m["Mirrors"]["Mirror"]["mirrorpath"]
    "http://thetvdb.com"
  end
  
  def self.get_episodes(series_id, season_id=nil)
    data = Hash.from_xml(
      open("http://thetvdb.com/api/#{API_KEY}/series/#{series_id}/all").read
    )
    data["Data"]["Episode"].select {|x| season_id ? (x["seasonid"].to_i == season_id.to_i) : true }
  end
  
  def self.save_episode_data(anime)
    if anime.thetvdb_series_id
      if anime.thetvdb_season_id and anime.thetvdb_season_id.to_s.length > 0
        reps = self.get_episodes(anime.thetvdb_series_id, anime.thetvdb_season_id)
      else
        reps = self.get_episodes(anime.thetvdb_series_id)
      end

      reps.each do |episode|
        # First, see if there is an existing item without a season number.
        e = anime.episodes.where(season_number: nil, number: episode["EpisodeNumber"]).first
        if e
          e.season_number = episode["SeasonNumber"]
          e.number = episode["EpisodeNumber"]
        else
          e = anime.episodes.where(season_number: episode["SeasonNumber"], number: episode["EpisodeNumber"]).first || Episode.create!(anime: anime, season_number: episode["SeasonNumber"], number: episode["EpisodeNumber"])
        end
        
        e.title = episode["EpisodeName"]
        e.save
      end
    end
    
    anime.episode_count = anime.episodes.length
    anime.save
  end
end
