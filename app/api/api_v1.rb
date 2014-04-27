require_relative 'entities.rb'
require 'message_formatter'

class API_v1 < Grape::API
  version 'v1', using: :path, format: :json, vendor: 'hummingbird'
  formatter :json, lambda {|object, env| MultiJson.dump(object) }
  rescue_from ActiveRecord::RecordNotFound

  helpers do
    def warden; env['warden']; end
    def current_user
      return env['current_user'] if env['current_user']
      if params[:auth_token] or cookies[:auth_token]
        user = User.find_by_authentication_token(params[:auth_token] || cookies[:auth_token])
        if user.nil?
          error!("Invalid authentication token", 401)
        end
        env['current_user'] = user
      else
        nil
      end
    end
    def user_signed_in?
      not current_user.nil?
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

    def present_watchlist(w, rating_type, title_language_preference)
      {
        id: w.id,
        episodes_watched: w.episodes_watched,
        last_watched: w.last_watched || w.updated_at,
        rewatched_times: w.rewatch_count,
        notes: w.notes,
        notes_present: (w.notes and w.notes.strip.length > 0),
        status: w.status.downcase.gsub(' ', '-'),
        private: w.private,
        rewatching: w.rewatching,
        anime: present_anime(w.anime, title_language_preference, false),
        rating: {
          type: rating_type,
          value: w.rating
        }
      }
    end

    def present_miniuser(user)
      {
        name: user.name,
        url: "http://hummingbird.me/users/#{user.name}",
        avatar: user.avatar.url(:thumb),
        avatar_small: user.avatar.url(:thumb_small),
        nb: user.ninja_banned?
      }
    end

    def present_anime(anime, title_language_preference, include_genres=true)
      if anime
        json = {
          slug: anime.slug,
          status: anime.status,
          url: "http://hummingbird.me/anime/#{anime.slug}",
          title: anime.canonical_title(title_language_preference),
          alternate_title: anime.alternate_title(title_language_preference),
          episode_count: anime.episode_count,
          cover_image: anime.poster_image_thumb,
          synopsis: anime.synopsis,
          show_type: anime.show_type
        }
        if include_genres
          json[:genres] = anime.genres.map {|x| {name: x.name} }
        end
        json
      else
        {}
      end
    end

    def present_favorite_anime(anime, title_language_preference, include_genres=true)
      if anime
        fav_anime = Anime.find(anime.item_id)
        json = {
          slug: fav_anime.slug,
          status: fav_anime.status,
          url: "http://hummingbird.me/anime/#{fav_anime.slug}",
          title: fav_anime.canonical_title(title_language_preference),
          alternate_title: fav_anime.alternate_title(title_language_preference),
          episode_count: fav_anime.episode_count,
          cover_image: fav_anime.poster_image_thumb,
          synopsis: fav_anime.synopsis,
          show_type: fav_anime.show_type,
          fav_rank: anime.fav_rank,
          fav_id: anime.id
        }
        if include_genres
          json[:genres] = fav_anime.genres.map {|x| {name: x.name} }
        end
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
            formatted_comment = MessageFormatter.format_message substory.data["comment"]
            substory.data["formatted_comment"] = formatted_comment
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
        user = User.where("LOWER(name) = ?", params[:username]).first
      elsif params[:email]
        user = User.where("LOWER(email) = ?", params[:email]).first
      end
      if user.nil? or (not user.valid_password? params[:password])
        error!("Invalid credentials", 401)
      end
      return user.authentication_token
    end

    desc "Return the current user."
    params do
      requires :username, type: String
    end
    get ':username' do
      user = find_user(params[:username])
      json = {
        name: user.name,
        waifu: user.waifu,
        waifu_or_husbando: user.waifu_or_husbando,
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
        online: user.online?,
        following: (user_signed_in? and user.followers.include?(current_user)),
	favorites: user.favorites
      }
      if user == current_user
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
      status = Watchlist.status_parameter_to_status(params[:status])

      watchlists = user.watchlists.includes(:anime)
      watchlists = watchlists.where(status: status) if status
      watchlists = watchlists.where(private: false) if user != current_user

      title_language_preference = params[:title_language_preference]
      if title_language_preference.nil? and current_user
        title_language_preference = current_user.title_language_preference
      end
      title_language_preference ||= "canonical"

      rating_type = user.star_rating? ? "advanced" : "simple"

      watchlists.map {|w| present_watchlist(w, rating_type, title_language_preference) }
    end

    desc "Returns the user's favorite Animes"
    params do
      requires :user_id, type: String
      optional :page, type: Integer
    end
    get ":user_id/favorite_anime" do
      @user = User.find(params[:user_id])
      @favorite_anime = @user.favorites.where(item_type: "Anime").order('fav_rank')
      @favorite_anime.map {|a| present_favorite_anime(a, @user.try(:title_language_preference) || "canonical")}
    end

    desc "Updates User's Favorite ranks"
    params do
      requires :user_id, type: String
      requires :id, type: Integer
      requires :fav_rank, type: Integer
    end
    post ":user_id/favorite_anime/update" do
      favorite = Favorite.find(params[:id])
      favorite.fav_rank = params[:fav_rank]
      favorite.save
    end    

    desc "Returns the user's feed."
    params do
      requires :user_id, type: String
      optional :page, type: Integer
    end
    get ":user_id/feed" do
      user = find_user(params[:user_id])

      # Find stories to display.
      stories = user.stories.for_user(current_user).order('updated_at DESC').includes(:substories, :user, :target).page(params[:page]).per(20)

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
      if current_user and (current_user.admin? or (current_user.id == story.user_id)) or (current_user.id == story.target_id)
        story.destroy
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

    desc "Update a specific anime's details in a user's library."
    params do
      requires :anime_slug, type: String
      optional :increment_episodes, type: String
      optional :rewatching, type: String
      optional :include_mal_id, type: String
    end
    post ':anime_slug' do
      authenticate_user!

      anime = Anime.find(params["anime_slug"])

      library_entry = LibraryEntry.where(user_id: current_user.id, anime_id: anime.id).first || LibraryEntry.new({user_id: current_user.id, anime_id: anime.id})

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
        if library_entry.rating == params[:rating].to_f
          library_entry.rating = nil
        else
          library_entry.rating = [ [0, params[:rating].to_f].max, 5].min
        end
        result = result and library_entry.save
      end

      if library_entry.episodes_watched_changed? and library_entry.episodes_watched == library_entry.anime.episode_count
        library_entry.status = "Completed"
      end

      Action.from_library_entry(library_entry)

      if library_entry.save
        wl = present_watchlist(library_entry.reload, rating_type, title_language_preference)
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

    desc "Returns similar anime."
    params do
      requires :id, type: String, desc: "anime ID"
      optional :limit, type: Integer, desc: "number of results (max/default 20)"
    end
    get ':id/similar' do
      anime = Anime.find(params[:id])
      similar_anime = []
      similar_json = JSON.load(open("http://app.vikhyat.net/anime_safari/related/#{anime.id}")).sort_by {|x| -x["sim"] }
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
  end
  get '/search/anime' do
    anime = Anime.accessible_by(current_ability).includes(:genres)
    results = anime.simple_search_by_title(params[:query]).limit(5)
    if results.length == 0
      results = anime.fuzzy_search_by_title(params[:query]).limit(5)
    end

    title_language_preference = current_user.try(:title_language_preference) || "canonical"

    results.map {|x| present_anime(x, title_language_preference, false) }
  end
end
