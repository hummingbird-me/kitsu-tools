class HomeController < ApplicationController
  before_filter :hide_cover_image
  #caches_action :index, layout: false, :if => lambda { not user_signed_in? }

  def index
    if user_signed_in?
      @forum_topics = Forem::Topic.by_most_recent_post.limit(10)

    else
      render :guest_index
    end
  end
  
  def dashboard
    authenticate_user!
    redirect_to user_path(current_user)
  end

  def privacy
  end
end
