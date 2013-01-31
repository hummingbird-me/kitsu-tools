class GenresController < ApplicationController
  def show
    @genre = Genre.find(params[:id])
    @animes = @genre.animes
  end
end
