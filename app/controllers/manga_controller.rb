class MangaController < ApplicationController
  def show
    @manga = Manga.find(params[:id])

    respond_to do |format|
      format.json { render json: @manga }

      format.html do
        if request.path != manga_path(@manga)
          return redirect_to @manga, status: :moved_permanently
        end

        preload_to_ember! @manga, serializer: FullMangaSerializer, root: "full_manga"
        render_ember
      end
    end
  end
end
