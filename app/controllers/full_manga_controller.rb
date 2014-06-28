class FullMangaController < ApplicationController
  def show
    manga = Manga.find params[:id]
    render json: manga, serializer: FullMangaSerializer
  end
end
