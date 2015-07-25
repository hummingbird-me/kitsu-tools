class CharactersController < ApplicationController
  def show
    character = Character.find params[:id]
    respond_to do |format|
      format.json { render json: character }
      format.html do
        preload_to_ember! character
        render_ember
      end
    end
  end
end
