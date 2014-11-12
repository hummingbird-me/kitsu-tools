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

  def index
    respond_to do |format|
      format.json do
        manga = Manga
        manga = Manga.where(slug: params[:ids]) if params[:ids]
        manga = Manga.order(params[:sort_by] + (params[:sort_reverse].nil? ? "" : " DESC")) if params[:sort_by]
        render json: manga.includes(:genres).page(params[:page]).per(40)
      end
    end
  end
end
