module Api::V2
  class MangaController < ApiController
    def show
      manga = Manga.find(params[:id])
      render json: manga
    end
  end
end
