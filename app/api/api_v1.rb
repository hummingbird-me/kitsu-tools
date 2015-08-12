class API_v1 < Grape::API
  version 'v1', using: :path, format: :json, vendor: 'hummingbird'
  formatter :json, lambda {|object, env| MultiJson.dump(object) }
  rescue_from ActiveRecord::RecordNotFound

  helpers do
    def current_user
      return env['current_user'] if env.has_key?('current_user')

      if params[:auth_token] || cookies[:auth_token]
        token = Token.new(params[:auth_token] || cookies[:auth_token])
        error! "Invalid authentication token", 401 if token.invalid?
        env['current_user'] = token.user
      else
        env['current_user'] = nil
      end

      env['current_user']
    end

    def user_signed_in?
      !current_user.nil?
    end

    def authenticate_user!
      if user_signed_in?
        return true
      else
        error!("401 Unauthenticated", 401)
      end
    end

    def current_ability
      @current_ability ||= Ability.new(current_user)
    end

    def find_user(id)
      begin
        if id == "me" and user_signed_in?
          current_user
        else
          User.find(id)
        end
      rescue
        error!("404 Not Found", 404)
      end
    end

    def save_favorite(key, value)
      item = value
      favorite = Favorite.find(item.id)
      if favorite.user == current_user
        favorite.fav_rank = item.fav_rank
        favorite.save
      else
        error!("Unauthorized", 403)
      end
    end

    def present_library_entry(e, rating_type, title_language_preference)
      {
        id: e.id,
        episodes_watched: e.episodes_watched,
        last_watched: e.last_watched || e.updated_at,
        updated_at: e.updated_at,
        rewatched_times: e.rewatch_count,
        notes: e.notes,
        notes_present: (e.notes and e.notes.strip.length > 0),
        status: e.status.downcase.gsub(' ', '-'),
        private: e.private,
        rewatching: e.rewatching,
        anime: present_anime(e.anime, title_language_preference),
        rating: {
          type: rating_type,
          value: e.rating
        }
      }
    end

    def present_miniuser(user)
      {
        name: user.name,
        url: "https://hummingbird.me/users/#{user.name}",
        avatar: user.avatar.url(:thumb),
        avatar_small: user.avatar.url(:thumb_small),
        nb: user.ninja_banned?
      }
    end

    def present_anime(anime, title_language_preference)
      if anime
        {
          id: anime.id,
          mal_id: anime.mal_id,
          slug: anime.slug,
          status: anime.status,
          url: "https://hummingbird.me/anime/#{anime.slug}",
          title: anime.canonical_title(title_language_preference),
          alternate_title: anime.alternate_title(title_language_preference),
          episode_count: anime.episode_count,
          episode_length: anime.episode_length,
          cover_image: anime.poster_image.url(:large),
          synopsis: anime.synopsis,
          show_type: anime.show_type,
          started_airing: anime.started_airing_date,
          finished_airing: anime.finished_airing_date,
          community_rating: anime.bayesian_rating,
          age_rating: anime.age_rating.blank? ? nil : anime.age_rating,
          genres: anime.genres.map {|x| {name: x.name} }
        }
      else
        {}
      end
    end

    def present_favorite_anime(favorite, title_language_preference)
      if favorite
        json = present_anime(favorite.item, title_language_preference)
        json[:fav_rank] = favorite.fav_rank
        json[:fav_id] = favorite.id
        json
      else
        {}
      end
    end

    def present_favorite(favorite)
      if favorite
        json = {
         id: favorite.id,
         item_type: favorite.item_type,
         fav_rank: favorite.fav_rank
        }
      else
       {}
      end
    end

    def present_story(story, current_user, title_language_preference)
      json = {
        id: story.id,
        story_type: story.story_type,
        user: present_miniuser(story.user),
        updated_at: story.updated_at,
      }
      if story.story_type == "comment"
        json[:self_post] = (story.target == story.user)
        json[:poster] = present_miniuser(story.target)
      elsif story.story_type == "media_story"
        json[:media] = present_anime(story.target, title_language_preference)
      end
      substories = story.substories
      json[:substories_count] = substories.length
      json[:substories] = substories.map do |substory|
        subjson = {
          id: substory.id,
          substory_type: substory.substory_type,
          created_at: substory.created_at
        }
        if substory.substory_type == "followed"
          subjson[:followed_user] = present_miniuser(substory.target)
        elsif substory.substory_type == "watchlist_status_update"
          subjson[:new_status] = (substory.data["new_status"] || "Currently Watching").downcase.gsub(' ', '_')
        elsif substory.substory_type == "watched_episode"
          subjson[:episode_number] = substory.data["episode_number"]
          subjson[:service] = substory.data["service"]
        elsif substory.substory_type == "comment"
          if substory.data["formatted_comment"].nil?
            data = substory.data.dup
            data["formatted_comment"] = MessageFormatter.format_message substory.data["comment"]
            substory.data = data
            substory.save
          end
          subjson[:comment] = substory.data["formatted_comment"]
        end
        if current_user and ((substory.user_id == current_user.id) or (story.user_id == current_user.id) or current_user.admin?)
          subjson[:permissions] = {destroy: true}
        else
          subjson[:permissions] = {}
        end
        subjson
      end
      json
    end
  end

  desc "Return the user's timeline"
  params do
    optional :page, type: Integer
  end
  get '/timeline' do
    if user_signed_in?
      NewsFeed.new(current_user).fetch(params[:page]).map {|x| present_story(x, current_user, current_user.title_language_preference) }
    else
      []
    end
  end

  resource :users do
    desc "Return authentication code"
    params do
      optional :username, type: String
      optional :email, type: String
      requires :password, type: String
    end
    post '/authenticate' do
      user = nil
      if params[:username]
        user = User.where("LOWER(name) = ?", params[:username].downcase).first
      elsif params[:email]
        user = User.where("LOWER(email) = ?", params[:email].downcase).first
      end
      if user.nil? || !user.valid_password?(params[:password])
        error! "Invalid credentials", 401
      end

      Token.new(user.id, scope: ['all']).encode
    end

    desc "Return the current user."
    params do
      requires :username, type: String
      optional :secret, type: String
    end
    get ':username' do
      user = find_user(params[:username])
      json = {
        name: user.name,
        waifu: user.waifu,
        waifu_or_husbando: user.waifu_or_husbando,
        waifu_slug: user.waifu_slug,
        waifu_char_id: user.waifu_char_id,
        location: user.location,
        website: user.website,
        avatar: user.avatar.url(:thumb),
        cover_image: user.cover_image.url(:thumb),
        about: user.about,
        bio: user.bio,
        karma: 0,
        life_spent_on_anime: user.life_spent_on_anime,
        show_adult_content: !user.sfw_filter?,
        title_language_preference: user.title_language_preference,
        last_library_update: user.last_library_update,
        following: (user_signed_in? and user.followers.include?(current_user)),
        favorites: user.favorites
      }
      if user == current_user || params[:secret] == ENV['FORUM_SYNC_SECRET']
        json["email"] = user.email
      end
      json
    end

    desc "Return the entries in a user's library under a specific status."
    params do
      requires :user_id, type: String
      optional :status, type: String
      optional :page, type: Integer
      optional :title_language_preference, type: String
    end
    get ':user_id/library' do
      if params[:page] and params[:page] > 1
        return []
      end

      user = find_user(params[:user_id])
      status = LibraryEntry::SNAKE_STATUSES[params[:status]]

      entries = user.library_entries
      entries = entries.where(status: status) if status
      entries = entries.where(private: false) if user != current_user

      title_language_preference = params[:title_language_preference]
      if title_language_preference.nil? and current_user
        title_language_preference = current_user.title_language_preference
      end
      title_language_preference ||= "canonical"

      rating_type = user.star_rating? ? "advanced" : "simple"

      entries.map {|e| present_library_entry(e, rating_type, title_language_preference) }
    end

    desc "Returns the user's favorite Animes"
    params do
      requires :user_id, type: String
      optional :page, type: Integer
    end
    get ":user_id/favorite_anime" do
      user = find_user(params[:user_id])
      favorite_anime = user.favorites.where(item_type: "Anime").includes(:item, item: :genres).order('fav_rank')
      favorite_anime.map {|a| present_favorite_anime(a, user.try(:title_language_preference) || "canonical")}
    end

    desc "Updates User's Favorite ranks"
    params do
      requires :data
    end
    post ":user_id/favorite_anime/update" do
      data = params[:data]
      data.each {|key,value| save_favorite(key,value)}
      data
    end

    desc "Returns the user's feed."
    params do
      requires :user_id, type: String
      optional :page, type: Integer
    end
    get ":user_id/feed" do
      user = find_user(params[:user_id])

      # Find stories to display.
      stories = user.stories.for_user(current_user)
                    .includes(:substories, :user, :target)
                    .order('updated_at DESC').page(params[:page]).per(20)
      # fetche anime stories and preload genres association
      # WORKAROUND: See rails/rails#17479
      anime_stories = stories.group_by(&:target_type).fetch("Anime",[])
      ActiveRecord::Associations::Preloader.new.preload(anime_stories, target: [:genres])

      stories.map {|x| present_story(x, current_user, current_user.try(:title_language_preference) || "canonical") }
    end

    desc "Returns the user's list of favorites"
    params do
      requires :user_id, type: String
    end
    get ":user_id/favorites" do
      @user = User.find(params[:user_id])
      @favorites = @user.favorites.order('fav_rank')
      @favorites.map {|f| present_favorite(f)}
    end

    desc "Delete a substory from the user's feed."
    params do
      requires :user_id, type: String
      requires :story_id, type: Integer
    end
    post ":user_id/feed/remove" do
      begin
        story = Story.find params[:story_id]
      rescue
        return true
      end
      if story.can_be_deleted_by?(current_user)
        story.destroy!
        return true
      else
        return false
      end
    end
  end

  resource :libraries do
    desc "Remove an entry"
    params do
      requires :anime_slug, type: String
    end
    post ':anime_slug/remove' do
      authenticate_user!

      anime = Anime.find(params["anime_slug"])
      library_entry = LibraryEntry.where(user_id: current_user.id, anime_id: anime.id).first
      library_entry.destroy
      true
    end

    desc "Get recently updated Entries"
    get '/recent' do
       entries = LibraryEntry.where(user_id: current_user).order("updated_at DESC").limit(12)

      {library_entries: entries.to_a}
    end

    desc "Update a specific anime's details in a user's library."
    params do
      requires :anime_slug, type: String
      optional :increment_episodes, type: String
      optional :rewatching, type: String
      optional :include_mal_id, type: String
      optional :title_language_preference, type: String
    end

    post ':anime_slug' do
      authenticate_user!

      anime = Anime.find(params["anime_slug"])

      library_entry = LibraryEntry.where(user_id: current_user.id, anime_id: anime.id).first_or_initialize

      if params[:status]
        t = {
          "currently-watching" => "Currently Watching",
          "plan-to-watch"      => "Plan to Watch",
          "completed"          => "Completed",
          "on-hold"            => "On Hold",
          "dropped"            => "Dropped"
        }
        library_entry.status = t[params[:status]]

        if library_entry.status == "Completed" and anime.episode_count
          # Mark all episodes as viewed when the show is "Completed".
          library_entry.episodes_watched = anime.episode_count
        end
      end

      # Update privacy.
      if params[:privacy]
        if params[:privacy] == "private"
          library_entry.private = true
        elsif params[:privacy] == "public"
          library_entry.private = false
        end
      end

      # Update rewatched_times.
      if params[:rewatched_times]
        library_entry.rewatch_count = params[:rewatched_times]
      end

      # Update notes.
      if params[:notes]
        library_entry.notes = params[:notes]
      end

      # Update episode count.
      if params[:episodes_watched]
        library_entry.episodes_watched = params[:episodes_watched]
      end

      # Update "rewatching" status.
      if params[:rewatching]
        library_entry.rewatching = (params[:rewatching] == "true")
      end

      if params[:increment_episodes] and params[:increment_episodes] == "true"
        library_entry.status = "Currently Watching"
        library_entry.episodes_watched += 1
      end

      title_language_preference = params[:title_language_preference]
      if title_language_preference.nil? and current_user
        title_language_preference = current_user.title_language_preference
      end
      title_language_preference ||= "canonical"
      rating_type = current_user.star_rating? ? "advanced" : "simple"

      # Update rating.
      if params[:rating]
        rating = params[:rating].to_f
        if library_entry.rating == rating or rating == 0
          library_entry.rating = nil
        else
          library_entry.rating = [ [0, rating].max, 5].min
        end
        result = result and library_entry.save
      end

      #Update rating without the weird behaviour.
      if params[:sane_rating_update]
        rating = params[:sane_rating_update].to_f
        if rating == 0
          library_entry.rating = nil
        else
          library_entry.rating = [ [0, rating].max, 5].min
        end
        result = result and library_entry.save
      end


      if library_entry.episodes_watched_changed? and library_entry.episodes_watched == library_entry.anime.episode_count
        library_entry.status = "Completed"
      end

      Action.from_library_entry(library_entry)

      if library_entry.save
        wl = present_library_entry(library_entry.reload, rating_type, title_language_preference)
        wl = wl.merge(mal_id: anime.mal_id) if params[:include_mal_id] == "true"
        wl
      else
        return false
      end
    end
  end

  resource :anime do
    desc "Return an anime"
    params do
      requires :id, type: String, desc: "anime ID"
      optional :title_language_preference, type: String
    end
    get ':id' do
      anime = Anime.find(params[:id])

      title_language_preference = params[:title_language_preference]
      if title_language_preference.nil? and current_user
        title_language_preference = current_user.title_language_preference
      end
      title_language_preference ||= "canonical"

      present_anime(anime, title_language_preference)
    end

    desc "Return an Anime Slug Searched From Character Id"
    params do
      requires :id, type: String, desc: "character ID"
    end
    get 'casting/:id' do
    casting = Casting.where(character_id: params[:id]).first.anime_id
    anime = Anime.find(casting)
    json = {anime_slug: anime.slug }
    json
    end

    desc "Returns similar anime."
    params do
      requires :id, type: String, desc: "anime ID"
      optional :limit, type: Integer, desc: "number of results (max/default 20)"
    end
    get ':id/similar' do
      anime = Anime.find(params[:id])
      similar_anime = []
      similar_json = JSON.load(open("http://app.vikhyat.net/anime_graph/related/#{anime.id}")).sort_by {|x| -x["sim"] }
      similar_json.each do |similar|
        sim = Anime.find_by_id(similar["id"])
        similar_anime.push(sim) if sim and similar_anime.length < (params[:limit] || 20)
      end
      similar_anime.map {|x| {id: x.slug, title: x.canonical_title, alternate_title: x.alternate_title, genres: x.genres.map {|x| {name: x.name} }, cover_image: x.poster_image.url(:large), url: anime_url(x)} }
    end
  end

  desc "Anime search API endpoint"
  params do
    requires :query, type: String, desc: "query string"
    optional :title_language_preference, type: String
  end
  get '/search/anime' do
    anime = Anime.accessible_by(current_ability).includes(:genres)
    results = anime.instant_search(params[:query]).limit(20)
    if results.length == 0
      results = anime.full_search(params[:query]).limit(20)
    end

    title_language_preference = params[:title_language_preference]
    if title_language_preference.nil? and current_user
      title_language_preference = current_user.title_language_preference
    end
    title_language_preference ||= "canonical"

    results.map {|x| present_anime(x, title_language_preference) }
  end
end
