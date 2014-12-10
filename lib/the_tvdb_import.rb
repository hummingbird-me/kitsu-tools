# Import episode data from TheTVDB.

class TheTvdbImport
  BASE_URL = "http://thetvdb.com/api"
  KEY = '21F012C4F48D4288'

  def initialize(anime)
    @anime = anime
    @series_id = anime.thetvdb_series_id
    @season_id = anime.thetvdb_season_id
  end

  def import!
    en, jp = fetch_series(all: true), fetch_series(lang: 'ja') || {}
    raise MissingDataError.new if en.nil? || en[:episode].blank?

    # Save the jp anime title.
    if jp[:series][:series_name]
      @anime.jp_title = jp[:series][:series_name]
      @anime.save!
    end

    # Extract episodes for the current season.
    season = en[:episode].select do |episode|
      return false unless episode.is_a?(Hash)
      @season_id.nil? ? episode[:season_number].to_i >= 1 # Exclude specials
                      : episode[:seasonid].to_i == @season_id
    end
    raise MissingDataError if season.length == 0

    # Make sure the episode count matches what we have on our end.
    if season.length != @anime.episode_count
      raise DataMismatchError.new
    end

    season.each do |ep|
      thumb_url = URI("http://thetvdb.com/banners/#{ep[:filename]}")
      thumb_type = Net::HTTP.start(thumb_url.host, thumb_url.port).head(thumb_url)['Content-Type']
      thumb_url = nil unless thumb_type.start_with?('image/')

      Episode.create_or_update_from_hash({
        anime: @anime,
        episode: ep[:episode_number],
        airdate: ep[:first_aired],
        season: ep[:season_number] || 1,
        title: ep[:episode_name],
        synopsis: ep[:overview],
        thumbnail: thumb_url
      })
    end
  end

  def self.import!(series_id)
    TheTvdbImport.new(series_id).import!
  end

  class APIError < StandardError; end
  class MissingDataError < StandardError; end
  class DataMismatchError < StandardError; end

  private

  def fetch_series(opts={})
    lang = opts[:lang] || 'en'
    all = opts[:all] || false
    fetch("series/#{@series_id}/#{all ? "all/" : ""}#{lang}.xml")
  end

  def fetch(path)
    begin
      hash = Hash.from_xml(open("#{BASE_URL}/#{KEY}/#{path}"))
      hash.deep_transform_keys! {|k| k.to_s.underscore.to_sym }
      hash[:data]
    rescue
      raise APIError.new
    end
  end
end
