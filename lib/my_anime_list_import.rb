class MyAnimeListImport
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

  STATUS_MAP = {
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

  def initialize(user, xml)
    @user = user
    @xml = xml
    # We need to do this because MAL is not decent enough to return valid XML. Try
    # to get rid of any characters that break Hash.from_xml because it expects XML
    # and not the crap MAL returns.
    @clean_xml = @xml.encode('ASCII-8BIT', invalid: :replace, undef: :replace, replace: '').split('').select {|x| x =~ VALID_XML_CHARS }.join.encode('UTF-8')
    @data = nil
  end

  def data
    if @data.nil?
      @data = []
      hashdata = Hash.from_xml(@clean_xml)
      hashdata = hashdata["myanimelist"]["anime"]
      hashdata.each do |indv|
        parsd = {
          mal_id: indv["series_animedb_id"].to_i,
          title: indv["series_title"],
          rating: indv["my_score"].to_i,
          episodes_watched: indv["my_watched_episodes"].to_i,
          status: STATUS_MAP[indv["my_status"]] || (raise "unknown status: #{indv["my_status"]}"),
          last_updated: Time.at(indv["my_last_updated"].to_i),
          notes: indv["my_tags"]
        }
        @data.push(parsd)
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
        wl = LibraryEntry.where(user_id: @user.id, anime_id: ani.id).first || LibraryEntry.new(user: @user, anime: ani)
        wl.status = item[:status]
        wl.update_episode_count item[:episodes_watched]
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
    if not_imported.length > 0
      comment += " The following were not imported:\n\n"
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
