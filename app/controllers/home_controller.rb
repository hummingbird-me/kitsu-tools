class HomeController < ApplicationController
  def index
    redirect_to anime_index_path
  end
end
