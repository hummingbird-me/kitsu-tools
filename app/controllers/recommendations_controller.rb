class RecommendationsController < ApplicationController
  def index
    authenticate_user!
    @hide_cover_image = true
    
    new_watchlist_hash = current_user.watchlist_hash + "b"
    if current_user.watchlist_hash != new_watchlist_hash
      current_user.update_attributes(
        watchlist_hash: new_watchlist_hash+"a",
        recommendations_up_to_date: false
      )
      RecommendingWorker.perform_async(current_user.id)
    end
    
    # TODO Load anime.
  end
end
