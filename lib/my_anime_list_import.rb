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
      hashdata = Hash.from_xml(@xml)["myanimelist"]

      @list = "manga" if hashdata.includes?("manga")

      @data = hashdata[@list].map do |indv|
        row = {
          rating: indv["my_score"].to_i,
          notes: indv["my_tags"]
        }
        if @list == "manga"
          row.merge!({
            mal_id: indv["manga_mangadb_id"].to_i,
            title: indv["manga_title"],

            status: MANGA_STATUS_MAP[indv["my_status"]] || "Currently Reading",
            volumes_read: indv["my_read_volumes"],
            chapters_read: indv["my_read_chapters"],
          })
        elsif @list == "anime"
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
    anime = Anime.where(mal_id: data.map {|x| x[:mal_id] }).index_by(&:mal_id)
    not_imported = []
    import_count = 0

    data.each do |item|
      ani = anime[ item[:mal_id] ]
      if ani.nil?
        not_imported.push ("* " + item[:title])
      else
        wl = LibraryEntry.where(user_id: @user.id, anime_id: ani.id).first || LibraryEntry.new(user_id: @user.id, anime_id: ani.id)
        wl.status = item[:status]
        wl.episodes_watched = item[:episodes_watched]
        if ani.episode_count and ani.episode_count > 0 and wl.episodes_watched > ani.episode_count
          wl.episodes_watched = ani.episode_count
        end
        wl.updated_at = item[:last_updated]
        wl.notes = item[:notes]
        wl.imported = true

        if item[:rating] != 0
          wl.rating = item[:rating].to_f / 2
        else
          wl.rating = nil
        end

        wl.save!
        import_count += 1
      end
    end

    comment = "Hey, we just finished importing #{import_count} titles from your MAL account."

    # If the user account was created in the last 24 hours add a welcome message.
    if @user.created_at >= 1.day.ago
      comment += " Welcome to Hummingbird!"
    end

    if not_imported.length > 0
      comment += "\n\nThe following were not imported:\n"
      comment += not_imported.join("\n")
    end

    Action.broadcast(
      action_type: "created_profile_comment",
      user: @user,
      poster: User.find(1),
      comment: comment
    )
  end

end
