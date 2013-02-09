class DashboardController < ApplicationController
  def index
    authenticate_user!
    @top_genres = current_user.top_genres
  end
end
