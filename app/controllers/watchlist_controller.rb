class WatchlistController < ApplicationController
  before_filter :authenticate_user!

  def add_to_watchlist
    @anime = Anime.find(params[:anime_id])
    @watch = Watchlist.find_or_create_by_anime_id_and_user_id(@anime.id, current_user.id)
    @watch.status = nil
    @watch.save
    redirect_to :back
  end

  def remove_from_watchlist
    @anime = Anime.find(params[:anime_id])
    @watch = Watchlist.find_by_anime_id_and_user_id(@anime.id, current_user.id)
    @watch.delete
    redirect_to :back
  end

  def update_rating
    @anime = Anime.find(params[:anime_id])
    @watch = Watchlist.find_or_create_by_anime_id_and_user_id(@anime.id, current_user.id)
    if params[:rating] == "positive"
      @watch.positive = true
    elsif params[:rating] == "negative"
      @watch.positive = false
    else
      @watch.positive = nil
    end
    @watch.save

    respond_to do |format|
      if request.xhr?
        format.js { render "replace_card" }
      end
      format.html { redirect_to :back }
    end
  end
end
