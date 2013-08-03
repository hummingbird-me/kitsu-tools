class HomeController < ApplicationController
  before_filter :hide_cover_image

  def index
    if user_signed_in?

      @onboarding = true if params[:signup_tour]

      respond_to do |format|
        format.html do
          @forum_topics = Forem::Topic.by_most_recent_post.joins(:user).where('NOT users.ninja_banned').limit(10)
          @recent_anime = current_user.watchlists.where(status: "Currently Watching").includes(:anime).order("last_watched DESC").limit(4)
          if @recent_anime.length < 4
            @recent_anime += current_user.watchlists.where("status <> 'Currently Watching'").includes(:anime).order("updated_at DESC, created_at DESC").limit(4 - @recent_anime.length)
          end
          @trending_anime = Rails.cache.fetch(:cached_trending_anime, expires_in: 5.minutes) do
            TrendingAnime.get.map {|x| {anime: Anime.find(x), currently_watching: Watchlist.where(anime_id: x, status: "Currently Watching").count} }
          end
        end
        format.json do
          timeline = NewsFeed.new(current_user).fetch(params[:page])
          render :json => timeline
        end
      end
      
    else

      respond_to do |format|
        format.html do
          # @hide_footer_ad = ab_test("footer_ad_on_guest_homepage", "show", "hide") == "hide"
          @hide_footer_ad = true
          render :guest_index
        end
        format.json do
          render :json => []
        end
      end

    end
  end
  
  def dashboard
    authenticate_user!
    redirect_to user_path(current_user)
  end

  def recommendations
  end

  def lists
  end
end
