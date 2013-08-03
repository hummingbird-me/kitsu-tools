require 'json'

class RecommendingWorker
  include Sidekiq::Worker

  # Maximum number of recommendations to save in each category.
  ITEM_LIMIT = 10
  
  def perform(user_id)
    user = User.find(user_id)

    # Get a user's list and favorite genres.
    user_watchlists = user.watchlists
    user_watchlists_anime_ids = (user_watchlists.map {|x| x.anime_id } + user.not_interested_anime.map {|x| x.id }).uniq
    favorite_genres = user.favorite_genres

    last_recommendations_update = Time.now

    similarities = {}
    anime = {}
    user_watchlists.each do |watchlist|
      similarities[watchlist.anime_id] ||= {}
      JSON.load( open("http://app.vikhyat.net/anime_safari/related/#{watchlist.anime.id}") ).each do |similar|
        similar_anime = Anime.find_by_id(similar["id"])
        if similar_anime and ["OVA", "ONA", "Movie", "TV"].include? similar_anime.show_type
          anime[similar_anime.id] = similar_anime
          similar_id = similar_anime.id
          similarities[watchlist.anime_id][similar_id] = similar["sim"]
        end
      end
    end

    # We want to categorize recommendations as follows.
    #
    # * General: based off the entire library.
    # * By status: based off of a particular watchlist section.
    # * By service: can be viewed in a service.
    # * By genre: belongs to genre.
    #
    # "General" and "By status" require one pass through the user's list to get
    # recommendations.
    #
    # "By service" and "By genre" are then generated in one pass through the "General"
    # recommendations.

    #
    ## First pass: generate "general" and "by status" recommendations.
    #
    raw_recommendations = {
      general: Hash.new(0),
      by_status: {
        currently_watching: Hash.new(0),
        plan_to_watch: Hash.new(0),
        completed: Hash.new(0)
      }
    }

    user_watchlists.each do |watchlist|
      similarities[watchlist.anime_id].each do |similar_id, similarity|
        # TODO: factor should probably take recency into account.
        factor = similarity * ((watchlist.rating || 3) - 2.7)

        raw_recommendations[:general][similar_id] += factor
        if watchlist.status == "Currently Watching"
          raw_recommendations[:by_status][:currently_watching][similar_id] += factor
        elsif watchlist.status == "Plan to Watch"
          raw_recommendations[:by_status][:plan_to_watch][similar_id] += factor
        elsif watchlist.status == "Completed"
          raw_recommendations[:by_status][:completed][similar_id] += factor
        end
      end
    end

    #
    ## Second pass: generate the actual full set of recommendations.
    #
    recommendations = {
      general: [],
      by_status: {
        currently_watching: [],
        plan_to_watch: [],
        completed: []
      },
      by_service: {
        neon_alley: []
      },
      by_genre: {
      }
    }
    favorite_genres.each {|genre| recommendations[:by_genre][genre.slug] = [] }

    # First, fill out the by_status sections.
    [:currently_watching, :plan_to_watch, :completed].each do |status|
      recs = raw_recommendations[:by_status][status].keys
      recs -= user_watchlists_anime_ids
      recs.sort_by {|sid| -raw_recommendations[:by_status][status][sid] }
      # Exclude hentai.
      recs.select! {|sid| anime[sid].sfw? }
      recs = recs[0...10] if recs.length > 10
      recommendations[:by_status][status] = recs
    end

    # Generate full "general" recommendations array.
    general = raw_recommendations[:general].keys
    general -= user_watchlists_anime_ids
    general.sort_by {|sid| -raw_recommendations[:general][sid] }

    # Top 10 general recommendations.
    recommendations[:general] = general.dup
    recommendations[:general].select {|sid| anime[sid].sfw? }
    recommendations[:general] = recommendations[:general][0...10] if recommendations[:general].length > 10

    # Get "by service" and "by genre" recommendations.
    genre_ids = {}
    general.each do |sid|
      genre_ids[sid] ||= anime[sid].genre_ids
      halt = true

      if recommendations[:by_service][:neon_alley].length < 10
        halt = false
        if Anime.neon_alley_ids.include? sid
          recommendations[:by_service][:neon_alley].push sid
        end
      end

      favorite_genres.each do |genre|
        if recommendations[:by_genre][genre.slug].length < 10
          halt = false
          if genre_ids[sid].include?(genre.id) and (genre.nsfw? or (genre.sfw? and anime[sid].sfw?))
            recommendations[:by_genre][genre.slug].push sid
          end
        end
      end

      break if halt
    end

    # Save this stuff to the database.
    user.recommendation.destroy if user.recommendation
    recommendation = Recommendation.create(user_id: user_id)
    recommendation.recommendations = {}

    recommendation.recommendations["general"] = recommendations[:general].to_json
    recommendation.recommendations["by_status"] = recommendations[:by_status].to_json
    recommendation.recommendations["by_service"] = recommendations[:by_service].to_json
    recommendation.recommendations["by_genre"] = recommendations[:by_genre].to_json

    recommendation.save
    
    user.update_column :recommendations_up_to_date, true
    user.update_column :last_recommendations_update, last_recommendations_update
  end
end
