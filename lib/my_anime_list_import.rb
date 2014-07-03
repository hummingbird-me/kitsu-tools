class MyAnimeListImport
  ANIME_STATUS_MAP = {
    "1"             => "Currently Watching",
    "watching"      => "Currently Watching",
    "Watching"      => "Currently Watching",
    "2"             => "Completed",
    "completed"     => "Completed",
    "Completed"     => "Completed",
    "3"             => "On Hold",
    "onhold"        => "On Hold",
    "On-Hold"       => "On Hold",
    "4"             => "Dropped",
    "dropped"       => "Dropped",
    "Dropped"       => "Dropped",
    "6"             => "Plan to Watch",
    "plantowatch"   => "Plan to Watch",
    "Plan to Watch" => "Plan to Watch"
  }
  MANGA_STATUS_MAP = {
    "1"             => "Currently Reading",
    "reading"       => "Currently Reading",
    "Reading"       => "Currently Reading",
    "2"             => "Completed",
    "completed"     => "Completed",
    "Completed"     => "Completed",
    "3"             => "On Hold",
    "onhold"        => "On Hold",
    "On-Hold"       => "On Hold",
    "4"             => "Dropped",
    "dropped"       => "Dropped",
    "Dropped"       => "Dropped",
    "6"             => "Plan to Read",
    "plantoread"    => "Plan to Read",
    "Plan to Read"  => "Plan to Read"
  }

  def initialize(user, xml)
    @user = user
    @xml = xml
    @data = nil
    @list = "anime"
  end

  def data
    if @data.nil?
      @data = []

      @data = hashdata[list].map do |indv|
        row = {
          rating: indv["my_score"].to_i,
          notes: indv["my_tags"]
        }
        if list == "manga"
          row.merge!({
            mal_id: indv["manga_mangadb_id"].to_i,
            title: indv["manga_title"],

            status: MANGA_STATUS_MAP[indv["my_status"]] || "Currently Reading",
            volumes_read: indv["my_read_volumes"].to_i,
            chapters_read: indv["my_read_chapters"].to_i,
          })
        elsif list == "anime"
          row.merge!({
            mal_id: indv["series_animedb_id"].to_i,
            title: indv["series_title"],

            status: ANIME_STATUS_MAP[indv["my_status"]] || "Currently Watching",
            episodes_watched: indv["my_watched_episodes"].to_i,
            last_updated: Time.at(indv["my_last_updated"].to_i)
          })
        end
        row
      end
    end
    @data
  end

  def apply!
    table = (list == "manga") ? Manga : Anime
    animangoes = table.where(mal_id: data.map {|x| x[:mal_id] }).index_by(&:mal_id)
    failures = []
    count = 0

    data.each do |mal_entry|
      animanga = animangoes[mal_entry[:mal_id]]
      if animanga.nil?
        failures << mal_entry[:title]
      else
        entry = nil
        if list == "manga"
          entry = MangaLibraryEntry.where(user_id: @user.id, manga_id: animanga.id).first_or_initialize
          entry.chapters_read = restrict_range(mal_entry[:chapters_read], animanga.chapter_count)
          entry.volumes_read  = restrict_range(mal_entry[:volumes_read], animanga.volume_count)
        else
          entry = LibraryEntry.where(user_id: @user.id, anime_id: animanga.id).first_or_initialize
          entry.episodes_watched = restrict_range(mal_entry[:episodes_watched], animanga.episode_count)
        end
        entry.status = mal_entry[:status]
        entry.updated_at = mal_entry[:last_updated]
        entry.notes = mal_entry[:notes]
        entry.imported = true
        entry.rating = mal_entry[:rating].to_f / 2
        entry.rating = nil if entry.rating == 0

        entry.save!
        count += 1
      end
    end

    comment = "Hey, we just finished importing #{count} titles from your MAL account."

    # If the user account was created in the last 24 hours add a welcome message.
    if @user.created_at >= 1.day.ago
      comment << " Welcome to Hummingbird!"
    end

    if failures.length > 0
      comment << "\n\nThe following were not imported:\n * "
      comment << failures.join("\n * ")
    end

    Action.broadcast(
      action_type: "created_profile_comment",
      user: @user,
      poster: User.find(1),
      comment: comment
    )
  end
  private
  def restrict_range(num, max)
    # FIXME: Hack because we use 0 instead of nil
    return num if max.nil? || max == 0
    [num, max].min
  end
  def hashdata
    if @hashdata.nil?
      @hashdata = Hash.from_xml(@xml)["myanimelist"]
    else
      @hashdata
    end
  end
  def list
    if hashdata.include?("manga")
      "manga"
    elsif hashdata.include?("anime")
      "anime"
    else
      raise "Unknown list type"
    end
  end

end
