class HomeController < ApplicationController
  def index
  end
  
  def dashboard
    authenticate_user!
    redirect_to user_path(current_user)
  end
end
