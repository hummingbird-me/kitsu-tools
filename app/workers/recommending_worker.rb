require 'json'

class RecommendingWorker
  include Sidekiq::Worker
  
  def top_recommendations(recommendations, options={})
    n         = options[:limit] || 10
    exclude   = options[:exclude] || []
    intersect = options[:intersect] || false
    filter    = options[:filter] || lambda {|anime_id| true }
    
    tr = []
    recommendations.each do |anime_id, score|
      unless exclude.include?(anime_id)
        if (!intersect or intersect.include?(anime_id)) and filter[anime_id]
          tr.push({anime_id: anime_id, score: score})
        end
      end
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
    user_watchlists_anime_ids = (user_watchlists.map {|x| x.anime_id } + user.not_interested_anime.map {|x| x.id }).uniq
    user_watchlists.each do |watchlist|
      similarities[watchlist.anime_id] ||= {}
      JSON.load( open("http://app.vikhyat.net/anime_safari/related/#{watchlist.anime.mal_id}") ).each do |similar|
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

    user.recommendation.destroy if user.recommendation
    recommendation = Recommendation.create(user_id: user_id)
    
    recommendation.recommendations ||= {}
    
    # Save top 20 "general" recommendations.
    recommendation.recommendations["general"] = top_recommendations(recommendations[:general]).to_json
    
    # Save "by status" recommendations.
    recommendation.recommendations["by_status"] = {
      currently_watching: top_recommendations(recommendations[:by_status][:currently_watching], exclude: user_watchlists_anime_ids),
      plan_to_watch: top_recommendations(recommendations[:by_status][:plan_to_watch], exclude: user_watchlists_anime_ids),
      completed: top_recommendations(recommendations[:by_status][:completed], exclude: user_watchlists_anime_ids)
    }.to_json
    
    # Save "by service" recommendations.
    recommendation.recommendations["by_service"] = {
      neon_alley: top_recommendations(recommendations[:general], intersect: Anime.neon_alley_ids, exclude: user_watchlists_anime_ids)
    }.to_json
    
    # Generate and save "favorite genre" recommendations.
    favorite_genre_recommendations = {}
    user.favorite_genres.each do |genre|
      favorite_genre_recommendations[genre.slug] = top_recommendations(recommendations[:general], exclude: user_watchlists_anime_ids, filter: lambda {|anime_id| Anime.find(anime_id).genres.include? genre })
    end
    recommendation.recommendations["by_genre"] = favorite_genre_recommendations.to_json
    
    recommendation.save
    
    user.update_column :recommendations_up_to_date, true
    user.update_column :last_recommendations_update, Time.now
  end
end
