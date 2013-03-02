class HomeController < ApplicationController
  def index
    @hide_cover_image = true
  end
  
  def dashboard
    authenticate_user!
    redirect_to user_path(current_user)
  end
end
