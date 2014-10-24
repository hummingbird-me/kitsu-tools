class MyAnimeListScrapeWorker
  include Sidekiq::Worker

  def perform(type, id)
    db = type.camelize.constantize
    db.create_or_update_from_hash(MALImport.new(type, id).to_h)
  end
end
