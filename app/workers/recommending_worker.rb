require 'json'

class RecommendingWorker
  include Sidekiq::Worker
  
  def top_recommendations(recommendations, n=10)
    tr = []
    recommendations.each do |anime_id, score|
      tr.push({anime_id: anime_id, score: score})
    end
    
    tr.sort_by! {|x| -x[:score] }
    tr = tr[0...n] if tr.length > n

    tr.map {|x| x[:anime_id] }
  end
  
  def perform(user_id)
    user = User.find(user_id)

    # Fetch relevant similarities from remote server.
    similarities = {}
    user_watchlists = user.watchlists
    user_watchlists.each do |watchlist|
      JSON.load( open("http://app.vikhyat.net/anime_safari/related/#{watchlist.anime.mal_id}") ).each do |similar|
        similarities[watchlist.anime_id] ||= {}
        similar_anime = Anime.find_by_mal_id(similar["id"])
        if similar_anime
          similar_id = similar_anime.id
          similarities[watchlist.anime_id][similar_id] = similar["sim"]
        end
      end
    end
    
    recommendations = {
      general: Hash.new(0),
      by_status: {
        currently_watching: Hash.new(0),
        plan_to_watch: Hash.new(0),
        completed: Hash.new(0)
      }
    }
    
    user_watchlists.each do |watchlist|

      similarities[watchlist.anime_id].each do |similar, similarity|
        factor = similarity * ((watchlist.rating || 0) + 1.5)
        recommendations[:general][similar] += factor
        if watchlist.status == "Currently Watching"
          recommendations[:by_status][:currently_watching][similar] += factor
        elsif watchlist.status == "Plan to Watch"
          recommendations[:by_status][:plan_to_watch][similar] += factor
        elsif watchlist.status == "Completed"
          recommendations[:by_status][:completed][similar] += factor
        end
      end
      
    end

    
    recommendation = user.recommendation || Recommendation.create(user_id: user_id)
    
    recommendation.recommendations ||= {}
    
    # Save top 20 "general" recommendations.
    recommendation.recommendations["general"] = top_recommendations(recommendations[:general]).to_json
    
    # Save "by status" recommendations.
    recommendation.recommendations["by_status"] = {
      currently_watching: top_recommendations(recommendations[:by_status][:currently_watching]),
      plan_to_watch: top_recommendations(recommendations[:by_status][:plan_to_watch]),
      completed: top_recommendations(recommendations[:by_status][:completed])
    }.to_json
    
    recommendation.save
    
    #user.update_column :recommendations_up_to_date, true
  end
end
