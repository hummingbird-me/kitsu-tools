class DashboardController < ApplicationController
  def index
    authenticate_user!
  end
end
