require 'json'

class RecommendingWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    watchlist = user.watchlists
    
    positive = watchlist.select {|w| w.positive? }.map {|x| x.anime }
    negative = watchlist.select {|w| w.negative? }.map {|x| x.anime }
    neutral  = ((watchlist - positive) - negative).map {|x| x.anime }

    recommendations = Hash.new(0)
    
    # TODO: Use own database for generating recommendations.
    [[positive, 1], [neutral, 0.1], [negative, -1]].each do |klass, weight|
      klass.each do |a|
        similars = JSON.load open("http://app.vikhyat.net/anime_safari/related/#{a.mal_id}")
        similars.each do |similar|
          recommendations[similar["id"]] += weight * similar["sim"]
        end
      end
    end
    
    user.transaction do
      Recommendation.where(user_id: user_id).delete_all
      
      # TODO: restrict the number of recommendations saved to the top N matches.
      recommendations.each do |k, v|
        a = Anime.find_by_mal_id(k)
        if a && !watchlist.map {|x| x.anime_id }.include?(a.id)
          Recommendation.create(
            user_id: user_id,
            anime_id: a.id,
            score: v
          )
        end
      end
    
      user.update_attributes(recommendations_up_to_date: true)
    end
  end
end
