require 'my_anime_list_import'

class ImportsController < ApplicationController
  before_filter :authenticate_user!

  def new
    hide_cover_image

    if params[:animelist]
      begin
        if params[:animelist].content_type == "text/xml"
          flash[:error] = "Please directly upload the file downloaded from MAL. There is no need to decompress it."
          redirect_to "/users/edit"
          return
        end

        gz = Zlib::GzipReader.new(params[:animelist])
        xml = gz.read
        gz.close
        current_user.update_column :mal_import_in_progress, true
        MyAnimeListImportApplyWorker.perform_async(current_user.id, xml)

        mixpanel.track "Imported from MyAnimeList", {email: current_user.email} if Rails.env.production?
      rescue
        flash[:error] = "There was a problem importing your anime list. Please send an email to <a href='mailto:josh@hummingbird.me'>josh@hummingbird.me</a> with the file you are trying to import.".html_safe
        redirect_to "/users/edit"
        return
      end
    end

    unless current_user.mal_import_in_progress?
      flash[:success] = "Import completed successfully."
      redirect_to user_path(current_user)
    end
  end
end
