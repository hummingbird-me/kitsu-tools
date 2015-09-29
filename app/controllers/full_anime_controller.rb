class FullAnimeController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  def show
    anime = Anime.find params[:id]
    render json: anime, serializer: FullAnimeSerializer
  end

  def update
    anime = Anime.find(params[:id])
    version = anime.create_pending(current_user, full_anime_params)
    # if this user is admin, apply the changes
    # without review, but still create a history version
    anime.update_from_pending(version) if current_user.admin?
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
      :cover_image, :cover_image_top_offset, :youtube_video_id,

      # versionable specific
      :started_airing, :finished_airing, :edit_comment
    )
  end
end
