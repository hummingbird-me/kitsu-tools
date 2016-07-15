class DataImportWorker
  include Sidekiq::Worker

  def perform(type, klass, id, opts = {})
    importer = klass.new(opts)
    case type
    when 'media'
      importer.get_media(id)
    end
  end
end
