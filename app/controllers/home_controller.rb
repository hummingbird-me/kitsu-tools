class HomeController < ApplicationController
  def index
    @anime = Anime.page(params[:page]).per(18)
    @genres = Genre.all

    if not user_signed_in?
      @watchlist = [false] * @anime.length
    else
      @watchlist = @anime.to_a.map do |x|
        Watchlist.where(:anime_id => x, :user_id => current_user).first
      end
    end
  end
end
