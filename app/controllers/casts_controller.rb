class CastsController < ApplicationController
  def index
    @anime = Anime.find(params[:anime_id])
    @casting = @anime.castings.includes(:character)
    respond_to do |format|
      format.json do
        if params[:type] == "character_names"
          render :json => @casting.where(featured: false).select {|x| x.character_id }.map {|x| x.character.name.strip }.uniq
        end
      end
    end
  end
end
