class DashboardController < ApplicationController
  def index
    authenticate_user!
    redirect_to user_path(current_user)
  end
end
