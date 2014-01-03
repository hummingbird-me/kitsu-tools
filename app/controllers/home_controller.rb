class HomeController < ApplicationController
  before_filter :hide_cover_image

  def index
    if user_signed_in?
      redirect_to "/dashboard"
    else
      @hide_footer_ad = true
      render :index
    end
  end

  def dashboard
    if user_signed_in?
      @onboarding = true if params[:signup_tour]

      @recent_anime = current_user.watchlists.where(status: "Currently Watching").includes(:anime).order("last_watched DESC").limit(4)
      if @recent_anime.length < 4
        @recent_anime += current_user.watchlists.where("status <> 'Currently Watching'").includes(:anime).order("updated_at DESC, created_at DESC").limit(4 - @recent_anime.length)
      end
      @trending_anime = Rails.cache.fetch(:cached_trending_anime, expires_in: 60.minutes) do
        TrendingAnime.get.map {|x| {anime: Anime.find(x), currently_watching: Watchlist.where(anime_id: x).count} }.dup
      end
    else
      redirect_to "/"
    end
  end

  def feed
    redirect_to "/api/v1/timeline?page=#{params[:page] || 1}"
  end

  def unsubscribe
    code = params[:code]
    User.all.select {|x| x.encrypted_email == code }.each {|x| x.update_attributes subscribed_to_newsletter: false }
    flash[:message] = "You have been unsubscribed from the newsletter."
    redirect_to "/anime"
  end

  def lists
  end
end
