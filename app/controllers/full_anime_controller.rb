class FullAnimeController < ApplicationController
  def show
    anime = Anime.find params[:id]
    render json: anime, serializer: FullAnimeSerializer
  end

  def destroy
    authenticate_user!
    if current_user.admin?
      Anime.find(params[:id]).delay.destroy
      render json: true
    else
      error! 400
    end
  end
end
