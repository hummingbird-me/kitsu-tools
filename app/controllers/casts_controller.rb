class CastsController < ApplicationController
  def index
    @anime = Anime.find(params[:anime_id])
    @casting = @anime.castings.includes(:character)
    respond_to do |f|
      f.json do
        if params[:type] == "character_names"
          render :json => @casting.select {|x| x.character_id }.map {|x| x.character.name }
        end
      end
    end
  end
end
