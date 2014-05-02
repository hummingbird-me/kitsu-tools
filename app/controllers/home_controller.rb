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
      @trending_anime = TrendingAnime.get.map do |x|
        anime = Anime.find(x)
        {anime: anime, currently_watching: anime.user_count}
      end
    else
      redirect_to "/"
    end

    if params.has_key?(:new_dash) or user_signed_in?
      render_ember
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
