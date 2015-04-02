class CharactersController < ApplicationController
  def show
    character = Character.find params[:id]
    respond_to do |format|
      format.json { render json: character }
      format.html {
        # Until we have character pages
        redirect_to character.primary_media
      }
    end
  end
end
