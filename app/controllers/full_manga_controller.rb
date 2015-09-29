class FullMangaController < ApplicationController
  def show
    manga = Manga.find params[:id]
    render json: manga, serializer: FullMangaSerializer
  end

  def update
    manga = Manga.find(params[:id])
    version = manga.create_pending(current_user, full_manga_params)
    # if this user is admin, apply the changes
    # without review, but still create a history version
    manga.update_from_pending(version) if current_user.admin?
    render json: true
  end

  private

  def full_manga_params
    params.require(:full_manga).permit(
      :synopsis, :chapter_count, :volume_count, :poster_image, :cover_image,
      :cover_image_top_offset,

      # versionable specific
      :edit_comment
    )
  end
end
