class AnimesController < ApplicationController
  def show
    respond_to do |format|
      format.json do
        render :text => Anime.find(params[:id].to_i).to_json
      end
    end
  end
end
