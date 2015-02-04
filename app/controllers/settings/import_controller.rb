require_dependency 'xml_cleaner'
require_dependency 'my_anime_list_import'

class Settings::ImportController < ApplicationController
  before_filter :authenticate_user!

  def myanimelist
    params.require(:file)

    # Prepare the file
    # Check the magic number for gzip because some browsers are stupid
    # Many users are uploading zipped-up lists with a text/xml MIME
    if file.readpartial(3) == 0x1F_8B_08
      gz = Zlib::GzipReader.new(file)
      xml = gz.read
      gz.close
    elsif file.content_type.include?('xml')
      xml = file.read
    else
      return error!(400, "Unknown format")
    end
    xml = XMLCleaner.clean(xml)

    return error!(422, "Blank file") if xml.blank?

    # Queue the import
    current_user.update_columns import_status: :queued,
                                import_from: 'myanimelist'
    MyAnimeListImportApplyWorker.perform_async(current_user.id, xml)

    render json: current_user

    mixpanel.track "Imported from MyAnimeList", {email: current_user.email} if Rails.env.production?
  rescue Exception
    error! 500, "There was a problem importing your anime list.  Please send an
                 email to vikhyat@hummingbird.me with the file you are trying
                 to import."
  end
end
