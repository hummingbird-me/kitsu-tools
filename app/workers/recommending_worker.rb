class RecommendingWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)

    # TODO: Do _actual_ recommendations.
    recommended_anime = Anime.all.select {|x| rand > 0.8 }

    user.transaction do
      Recommendation.delete_all(:user_id => user_id)
      recommended_anime.each do |anime|
        recommendation = Recommendation.new
        recommendation.user_id  = user_id
        recommendation.anime_id = anime.id
        recommendation.score    = rand
        recommendation.save
      end
    end
  end
end
