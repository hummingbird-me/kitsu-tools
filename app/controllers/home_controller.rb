class HomeController < ApplicationController
  def index
    @hide_cover_image = true
    @latest_reviews = Review.order('created_at DESC').limit(2)
    @popular_anime = Anime.order('wilson_ci DESC').limit(4)
  end
  
  def dashboard
    authenticate_user!
    redirect_to user_path(current_user)
  end
end
