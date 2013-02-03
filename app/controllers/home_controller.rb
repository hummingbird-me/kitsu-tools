class HomeController < ApplicationController
  def index
    @anime = Anime.all

    if not user_signed_in?
      @watchlist = [false] * @anime.length
    else
      @watchlist = @anime.map do |x|
        Watchlist.where(:anime_id => x, :user_id => current_user).first
      end
    end
  end
end
