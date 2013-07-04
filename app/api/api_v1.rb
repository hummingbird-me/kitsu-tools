require_relative 'entities.rb'

class API_v1 < Grape::API
  version 'v1', using: :path, format: :json, vendor: 'hummingbird'

  #
  # Log response time to Riemann.
  #
  before do
    @start_time = Time.now
  end
  
  after do
    @end_time = Time.now
    lat = (@end_time - @start_time).to_f
    $riemann << {
      service: "api req",
      metric: lat,
      state: "ok"
    }
  end
  
  helpers do
    def warden; env['warden']; end
    def current_user
      warden.user
    end
    def user_signed_in?
      not current_user.nil?
    end
    def current_ability
      @current_ability ||= Ability.new(current_user)
    end
  end

  
  resource :users do
    desc "Return the entries in a user's library under a specific status.", {
      object_fields: Entities::Watchlist.documentation
    }
    params do
      requires :user_id, type: String
      requires :status, type: String
      optional :page, type: Integer
      optional :title_language_preference, type: String
    end
    get ':user_id/library' do
      @user = User.find(params[:user_id])
      status = Watchlist.status_parameter_to_status(params[:status])

      watchlists = @user.watchlists.accessible_by(current_ability).where(status: status).includes(:anime).page(params[:page]).per(100)
      
      if status == "Currently Watching"
        watchlists = watchlists.order('last_watched DESC')
      else
        watchlists = watchlists.order('created_at DESC')
      end
      
      title_language_preference = params[:title_language_preference]
      if title_language_preference.nil? and current_user
        title_language_preference = current_user.title_language_preference
      end
      title_language_preference ||= "canonical"
      
      present watchlists, with: Entities::Watchlist, title_language_preference: title_language_preference, genres: false
    end
    
    desc "Returns the user's feed."
    params do
      requires :user_id, type: String
      optional :page, type: Integer
    end
    get ":user_id/feed" do
      @user = User.find(params[:user_id])
      @stories = @user.stories.accessible_by(current_ability).order('updated_at DESC').includes(:substories).page(params[:page]).per(20)
      
      present @stories, with: Entities::Story, current_ability: current_ability, title_language_preference: (user_signed_in? ? current_user.title_language_preference : "canonical")
    end
    
    desc "Delete a substory from the user's feed."
    params do
      requires :user_id, type: String
      requires :substory_id, type: Integer
    end
    post ":user_id/feed/remove" do
      substory = Substory.find params[:substory_id]
      if current_ability.can? :destroy, substory
        substory.destroy
        return true
      else
        return false
      end
    end
  end
  
  resource :libraries do
    desc "Update a specific anime's details in a user's library."
    params do
      requires :anime_slug, type: String
    end
    post ':anime_slug' do
      return false unless user_signed_in?

      @anime = Anime.find(params["anime_slug"])
      @watchlist = Watchlist.find_or_create_by_anime_id_and_user_id(@anime.id, current_user.id)
        
      # Update status.
      if params[:status]
        status = Watchlist.status_parameter_to_status(params[:status])
        if @watchlist.status != status
          # Create an action if the status was changed.
          Substory.from_action({
            user_id: current_user.id,
            action_type: "watchlist_status_update",
            anime_id: @anime.slug,
            old_status: @watchlist.status,
            new_status: status,
            time: Time.now
          })
        end
        @watchlist.status = status if Watchlist.valid_statuses.include? status
      end
      
      # Update privacy.
      if params[:privacy]
        if params[:privacy] == "private"
          @watchlist.private = true
        elsif params[:privacy] == "public"
          @watchlist.private = false
        end
      end

      # Update rating.
      if params[:rating]
        if @watchlist.rating == params[:rating].to_i
          @watchlist.rating = nil
        else
          @watchlist.rating = [ [-2, params[:rating].to_i].max, 2 ].min
        end
      end

      # Update rewatched_times.
      if params[:rewatched_times]
        @watchlist.update_rewatched_times params[:rewatched_times]
      end

      # Update notes.
      if params[:notes]
        @watchlist.notes = params[:notes]
      end
      
      # Update episode count.
      if params[:episodes_watched]
        @watchlist.update_episode_count params[:episodes_watched]
      end

      if params[:increment_episodes]
        @watchlist.update_episode_count((@watchlist.episodes_watched||0)+1)
        if current_user.neon_alley_integration? and Anime.neon_alley_ids.include? @anime.id
          service = "neon_alley"
        else
          service = nil
        end
        Substory.from_action({
          user_id: current_user.id,
          action_type: "watched_episode",
          anime_id: @anime.slug,
          episode_number: @watchlist.episodes_watched,
          service: service
        })
      end
      
      title_language_preference = params[:title_language_preference]
      if title_language_preference.nil? and current_user
        title_language_preference = current_user.title_language_preference
      end
      title_language_preference ||= "canonical"
      
      if @watchlist.save
        present @watchlist, with: Entities::Watchlist, title_language_preference: title_language_preference
      else
        return false
      end
    end
  end
  
  resource :anime do
    desc "Return an anime"
    params do
      requires :id, type: String, desc: "anime ID"
    end
    get ':id' do
      anime = Anime.find(params[:id])
      {title: anime.canonical_title, alternate_title: anime.alternate_title, url: anime_url(anime)}
    end
    
    desc "Returns similar anime."
    params do
      requires :id, type: String, desc: "anime ID"
      optional :limit, type: Integer, desc: "number of results (max/default 20)"
    end
    get ':id/similar' do
      anime = Anime.find(params[:id])
      similar_anime = []
      similar_json = JSON.load(open("http://app.vikhyat.net/anime_safari/related/#{anime.mal_id}")).sort_by {|x| -x["sim"] }
      similar_json.each do |similar|
        sim = Anime.find_by_mal_id(similar["id"])
        similar_anime.push(sim) if sim and similar_anime.length < (params[:limit] || 20)
      end
      similar_anime.map {|x| {id: x.slug, title: x.canonical_title, alternate_title: x.alternate_title, genres: x.genres.map {|x| {name: x.name} }, cover_image: x.cover_image.url(:thumb), url: anime_url(x)} }
    end
  end
end
