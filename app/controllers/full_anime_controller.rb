class FullAnimeController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  def show
    anime = Anime.find params[:id]
    render json: anime, serializer: FullAnimeSerializer
  end

  def update
    Anime.find(params[:id]).create_pending(current_user, full_anime_params)
    render json: true
  end

  def destroy
    if current_user.admin?
      Anime.find(params[:id]).delay.destroy
      render json: true
    else
      error! 400
    end
  end

  private

  def full_anime_params
    params.require(:full_anime).permit(
      :synopsis, :episode_length, :episode_count, :poster_image,
      :cover_image, :cover_image_top_offset, :youtube_video_id
    )
  end
end
