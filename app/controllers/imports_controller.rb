require 'my_anime_list_import'

class ImportsController < ApplicationController
  before_filter :authenticate_user!

  def new
    hide_cover_image

    if params[:animelist]
      if params[:animelist].content_type !="application/x-gzip"
        flash[:error] = "Please directly upload the compressed file you downloaded from MAL."
        redirect_to "/users/edit"
        return
      end
      gz = Zlib::GzipReader.new(params[:animelist])
      xml = gz.read
      gz.close
      current_user.update_column :mal_import_in_progress, true
      MyAnimeListImportApplyWorker.perform_async(current_user.id, xml)
    end
    unless current_user.mal_import_in_progress?
      flash[:success] = "Import completed successfully."
      redirect_to "/users/edit"
    end
  end
end
