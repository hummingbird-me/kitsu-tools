require_dependency 'library_entry_query'

class HomeController < ApplicationController
  before_filter :hide_cover_image

  def index
    if user_signed_in?
      redirect_to "/dashboard"
    else
      render_ember
    end
  end

  def dashboard
    unless user_signed_in?
      redirect_to root_url
      return
    end

    recent_library_entries = LibraryEntryQuery.find(
      user_id: current_user.id,
      recent: true,
      include_private: true,
      include_adult: !current_user.sfw_filter?
    )
    generic_preload! "recent_library_entries", ed_serialize(recent_library_entries, serializer: LibraryEntrySerializer)

    stories = NewsFeed.new(current_user).fetch(1)
    generic_preload! "dashboard_timeline", ed_serialize(stories)

    break_counter = $redis.with {|conn| conn.get("break_counter") } || 0
    generic_preload! "break_counter", break_counter

    render_ember
  end

  def feed
    redirect_to "/api/v1/timeline?page=#{params[:page] || 1}"
  end

  def static
    render_ember
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
