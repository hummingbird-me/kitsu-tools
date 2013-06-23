class HomeController < ApplicationController
  before_filter :hide_cover_image
  #caches_action :index, layout: false, :if => lambda { not user_signed_in? }

  def index
    if user_signed_in?

      respond_to do |format|
        format.html do
          @forum_topics = Forem::Topic.by_most_recent_post.limit(10)
          @recent_anime = current_user.watchlists.where(status: "Currently Watching").includes(:anime).order("last_watched DESC").limit(4)
        end
        format.json do
          @stories = Story.accessible_by(current_ability).order('updated_at DESC').where(user_id: current_user.following.map {|x| x.id } + [current_user.id]).page(params[:page]).per(20)
          render :json => Entities::Story.represent(@stories)
        end
      end
      
    else
      @hide_footer_ad = ab_test("footer_ad_on_guest_homepage", "show", "hide") == "hide"
      render :guest_index
    end
  end
  
  def dashboard
    authenticate_user!
    redirect_to user_path(current_user)
  end

  def recommendations
  end
end
