class AnimesController < ApplicationController
  def show
    @anime = Anime.find(params[:id])

    respond_to do |format|
      format.json { render :text => @anime.to_json }
    end
  end
end
