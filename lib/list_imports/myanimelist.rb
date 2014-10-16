module ListImport; end
class ListImport::MyAnimeList
  include Enumerable

  # Xinil wouldn't know what "normalized" meant if it bit him in the face
  # And where's 5 at?  Lord only knows.  RIP five, I knew ye well.
  COMMON_STATUS_MAP = {
    "2"             => "Completed",
    "completed"     => "Completed",
    "3"             => "On Hold",
    "onhold"        => "On Hold",
    "4"             => "Dropped",
    "dropped"       => "Dropped",
  }
  ANIME_STATUS_MAP = COMMON_STATUS_MAP.merge({
    "1"             => "Currently Watching",
    "watching"      => "Currently Watching",
    "6"             => "Plan to Watch",
    "plantowatch"   => "Plan to Watch",
  })
  MANGA_STATUS_MAP = COMMON_STATUS_MAP.merge({
    "1"             => "Currently Reading",
    "reading"       => "Currently Reading",
    "6"             => "Plan to Read",
    "plantoread"    => "Plan to Read",
  })

  private
  # Normalize the keys to lowercase, spaceless, dashless.
  def clean_status(status)
    status.gsub(' ', '').gsub('-', '').downcase
  end

  # Scrape the row from MAL
  def scrape(list, mal_id)
    @db.create_or_update_from_hash(MALImport.new(list, mal_id))
  end


  public
  def initialize(str)
    data = Hash.from_xml(str)['myanimelist']

    @media_type = data.keys.last.to_sym
    raise 'Unknown list type' unless [:anime, :manga].include?(@media_type)

    @db = @media_type.to_s.camelize.constantize
    @data = data[@media_type.to_s]
    # Hash.from_xml won't wrap in an array if it's only one row
    @data = [@data] unless @data.is_a? Array
  end

  def each
    status_map = "ListImport::MyAnimeList::#{@media_type.upcase}_STATUS_MAP".constantize
    @data.each do |row|
      mal_id = (row['series_animedb_id'] || row['manga_mangadb_id']).to_i
      media = @db.where(mal_id: mal_id).first
      if media.nil?
        media = scrape(@media_type, mal_id)
      end

      hash = {
        media: media,
        updated_at: Time.now,
        rating: row['my_score'].to_f / 2,
        notes: row['my_comments'].blank? ? row['my_tags'] : row['my_comments'],
        status: status_map[clean_status(row['my_status'])],
        episodes_watched: row['my_episodes_watched'].to_i,
        rewatch_count: row['my_times_rewatched'].to_i,
        rewatching: row['my_rewatching'] == "1",
        volumes_read: row['my_read_volumes'].to_i,
        chapters_read: row['my_read_chapters'].to_i,
        reread_count: row['my_times_read'].to_i
      }.compact
      hash['rating'] = nil if hash['rating'] == 0

      yield hash
    end
  end

  def media_type
    @media_type
  end

  def count
    @data.count
  end
end
