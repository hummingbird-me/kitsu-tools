class HomeController < ApplicationController
  def index
    redirect_to anime_index_path
  end
  
  def dashboard
    authenticate_user!
    redirect_to user_path(current_user)
  end
end
