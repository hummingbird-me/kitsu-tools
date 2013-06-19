class HomeController < ApplicationController
  before_filter :hide_cover_image
  #caches_action :index, layout: false, :if => lambda { not user_signed_in? }

  def index
    if user_signed_in? and current_user.id < 2000

      respond_to do |format|
        format.html do
          @forum_topics = Forem::Topic.by_most_recent_post.limit(10)
          @recent_anime = current_user.watchlists.where(status: "Currently Watching").includes(:anime).order("last_watched DESC").limit(4)
        end
        format.json do
          @stories = Story.accessible_by(current_ability).order('updated_at DESC').where(user_id: current_user.following.map {|x| x.id } + [current_user.id]).limit(30)
          render :json => Entities::Story.represent(@stories)
        end
      end
      
    elsif user_signed_in?

      @recent_anime_users = Rails.cache.fetch(:recent_anime_users_home, :expires_in => 10.seconds) { User.joins(:watchlists).where('watchlists.episodes_watched > 0').order('MAX(watchlists.last_watched) DESC').group('users.id').limit(8) }
      @recent_anime = Rails.cache.fetch(:recent_anime_home, :expires_in => 10.seconds) { @recent_anime_users.map {|x| x.watchlists.where("EXISTS (SELECT 1 FROM anime WHERE anime.id = anime_id AND age_rating <> 'R18+')").order('updated_at DESC').limit(1).first }.sort_by {|x| x.last_watched || x.updated_at }.reverse }
      @latest_reviews = Review.order('created_at DESC').limit(2)

      render :old_index

    else
      render :guest_index
    end
  end
  
  def dashboard
    authenticate_user!
    redirect_to user_path(current_user)
  end
end
