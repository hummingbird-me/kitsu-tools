class HomeController < ApplicationController
  def index
    @anime = Anime.all
  end
end
