class AnimesController < ApplicationController
  def show
    @anime = Anime.find(params[:id])

    respond_to do |format|
      format.html { render :show }
    end
  end
end
