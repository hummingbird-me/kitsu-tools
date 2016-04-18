require_dependency 'xml_cleaner'
require_dependency 'my_anime_list_import'

class Settings::ImportController < ApplicationController
  before_filter :authenticate_user!

  def myanimelist
    file = params.require(:file)

    # Prepare the file
    # Check the magic number for gzip because some browsers are stupid
    # Many users are uploading zipped-up lists with a text/xml MIME
    if file.content_type.include?('gzip') ||
       file.tempfile.readpartial(3).unpack('H*').first == '1f8b08'
      file.rewind
      gz = Zlib::GzipReader.new(file)
      xml = gz.read
      gz.close
    elsif file.content_type.include?('xml')
      xml = File.read(file.tempfile)
    else
      return error!(400, 'Unknown format')
    end

    #### This is how we fix Xinil being a bad programmer
    # Scrub invalid characters
    xml.scrub!
    # Properly escape ampersands
    xml.gsub!(/&(?!(?:amp|lt|gt|quot|apos);)/, '&amp;')

    #### These are all based on real user errors we've seen in logs
    return error!(422, 'Blank file') if xml.blank?
    return error!(422, 'Invalid MAL export') unless xml.include?('<myanimelist>')
    unless /<(?:anime|manga)>/.match(xml)
      return error!(422, 'No anime or manga entries found in your export')
    end

    # Queue the import
    status = User.import_statuses[:queued]
    current_user.update_columns import_status: status,
                                import_from: 'myanimelist'
    MyAnimeListImportApplyWorker.perform_async(current_user.id, xml)

    render json: current_user, serializer: CurrentUserSerializer

    mixpanel.track 'Imported from MyAnimeList', {email: current_user.email} if Rails.env.production?
  rescue Exception
    status = User.import_statuses[:error]
    current_user.update_columns import_status: status,
      import_error: 'There was a problem importing your list. Please send an email
                    to josh@hummingbird.me with the file you are trying to import
                    and we\'ll see what we can do.'
    raise
  end
end
