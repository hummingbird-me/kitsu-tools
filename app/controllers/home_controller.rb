class HomeController < ApplicationController
  def hide_cover_image
    @hide_cover_image = true
  end

  before_filter :hide_cover_image
  #caches_action :index, layout: false, :if => lambda { not user_signed_in? }

  def index
    @latest_reviews = Review.order('created_at DESC').limit(2)

    @recent_anime_users = User.joins(:watchlists).where('watchlists.episodes_watched > 0').order('MAX(watchlists.last_watched) DESC').group('users.id').limit(8)
    @recent_anime = @recent_anime_users.map {|x| x.watchlists.where("EXISTS (SELECT 1 FROM anime WHERE anime.id = anime_id AND age_rating <> 'Rx')").order('updated_at DESC').limit(1).first }.sort_by {|x| x.last_watched || x.updated_at }.reverse
  end
  
  def dashboard
    authenticate_user!
    redirect_to user_path(current_user)
  end
end
