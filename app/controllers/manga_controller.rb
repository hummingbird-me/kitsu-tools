class MangaController < ApplicationController
  def show
    manga = Manga.find(params[:id])

    if request.path != manga_path(manga)
      return redirect_to manga, status: :moved_permanently
    end

    preload! "manga", manga

    render_ember
  end
end
