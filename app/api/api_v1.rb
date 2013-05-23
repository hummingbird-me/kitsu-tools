class API_v1 < Grape::API
  version 'v1', using: :path, format: :json, vendor: 'hummingbird'

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
  
  resource :anime do
    desc "Return an anime"
    params do
      requires :id, type: String, desc: "anime ID"
    end
    get ':id' do
      anime = Anime.find(params[:id])
      {title: anime.canonical_title, alternate_title: anime.alternate_title}
    end
    
    desc "Returns similar anime."
    params do
      requires :id, type: String, desc: "anime ID"
      optional :limit, type: Integer, desc: "number of results (max/default 20)"
    end
    get ':id/similar' do
      anime = Anime.find(params[:id])
      similar_anime = []
      JSON.load(open("http://app.vikhyat.net/anime_safari/related/#{anime.mal_id}")).each do |similar|
        if similar.length < (params[:limit] || 20)
          similar_anime.push Anime.find_by_mal_id(similar["id"])
        end
      end
      similar_anime.map {|x| {id: x.slug, title: x.canonical_title, alternate_title: x.alternate_title, genres: x.genres} }
    end
  end
end
