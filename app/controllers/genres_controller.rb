class GenresController < ApplicationController
  def show
    redirect_to anime_index_path(:genres => params[:id])
  end
end
