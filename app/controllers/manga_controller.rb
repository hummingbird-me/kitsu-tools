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
        unless params[:sort_by].nil?
          manga = Manga.all.order(params[:sort_by]).page(params[:page]).per(40)
          unless params[:sort_reverse].nil?
            manga = Manga.all.order(params[:sort_by] + ' DESC').page(params[:page]).per(40)
          end
        else 
          manga = Manga.where(slug: params[:ids])
        end

        render json: manga
      end
    end
  end
end
