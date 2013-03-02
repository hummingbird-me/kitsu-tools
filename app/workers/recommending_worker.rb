require 'json'

class RecommendingWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    
    recommendations = Hash.new(0)

    user.watchlists.each do |watchlist|
      JSON.load(open("http://app.vikhyat.net/anime_safari/related/#{watchlist.anime.mal_id}")).each do |similar|
        recommendations[ similar["id"] ] += (watchlist.rating || 0) * similar["sim"]
      end
    end
    
    top_recommendations = []
    recommendations.each do |anime_id, score|
      top_recommendations.push( {anime_id: anime_id, score: score} )
    end
    top_recommendations = top_recommendations[0..99] if top_recommendations.length > 100
    
    user.transaction do
      Recommendation.where(user_id: user_id).delete_all
      
      top_recommendations.each do |rec|
        anime = Anime.find_by_mal_id( rec[:anime_id] )
        if anime && !user.watchlists.map {|x| x.anime_id }.include?(anime.id)
          Recommendation.create(
            user_id: user_id,
            anime_id: anime.id,
            score: rec[:score]
          )
        end
      end
    
      user.update_attributes(recommendations_up_to_date: true)
    end
  end
end
