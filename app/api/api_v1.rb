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
  
  #
  # `current_ability` for CanCan.
  #
  helpers do
    def warden; env['warden']; end
    def current_user
      warden.user
    end
    def current_ability
      @current_ability ||= Ability.new(current_user)
    end
  end

  
  resource :users do
    desc "Return the entries in a user's library under a specific status."
    params do
      requires :user_id, type: String
      requires :status, type: String
      optional :page, type: Integer
    end
    get ':user_id/library' do
      @user = User.find(params[:user_id])
      status = Watchlist.status_parameter_to_status(params[:status])

      watchlists = @user.watchlists.accessible_by(current_ability).where(status: status).includes(:anime).page(params[:page]).per(50)
      
      if status == "Currently Watching"
        watchlists = watchlists.order('last_watched DESC')
      else
        watchlists = watchlists.order('created_at DESC')
      end

      watchlists.map {|x| x.to_hash current_user }
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
        similar_anime.push(sim) if sim and similar_anime.length < params[:limit]
      end
      similar_anime.map {|x| {id: x.slug, title: x.canonical_title, alternate_title: x.alternate_title, genres: x.genres.map {|x| {name: x.name} }, cover_image: x.cover_image.url(:thumb), url: anime_url(x)} }
    end
  end
end
