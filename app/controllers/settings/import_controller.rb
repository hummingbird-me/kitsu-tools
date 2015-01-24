require_dependency 'xml_cleaner'
require_dependency 'my_anime_list_import'

class Settings::ImportController < ApplicationController
  before_filter :authenticate_user!

  def myanimelist
    hide_cover_image

    if params[:animelist]
      file = params[:animelist]
      begin
        # Check the magic number for gzip because some browsers are stupid
        # Many users are uploading zipped-up lists with a text/xml MIME
        if file.readpartial(3) == 0x1F_8B_08
          gz = Zlib::GzipReader.new(file)
          xml = gz.read
          gz.close
        elsif file.content_type.include?('xml')
          xml = file.read
        else
          raise "Unknown format"
        end

        xml = XMLCleaner.clean(xml)

        raise "Blank file" if xml.blank?

        current_user.update_column :mal_import_in_progress, true
        MyAnimeListImportApplyWorker.perform_async(current_user.id, xml)

        mixpanel.track "Imported from MyAnimeList", {email: current_user.email} if Rails.env.production?
      rescue Exception => e
        flash[:error] = "There was a problem importing your anime list (#{e.message}).  Please send an email to <a href='mailto:vikhyat@hummingbird.me'>vikhyat@hummingbird.me</a> with the file you are trying to import.".html_safe
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
