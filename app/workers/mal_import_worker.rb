require 'nokogiri'
require 'open-uri'

class MALImportWorker
  include Sidekiq::Worker

  sidekiq_options throttle: {threshold: 1, period: 1.second}

  def perform(mal_username, staged_import_id)
    staged_import = StagedImport.find(staged_import_id)
    return if staged_import.nil?
    
    apply = true if staged_import.data[:apply]
    
    username = mal_username

    watchlist = MalImport.fetch_watchlist_from_remote(mal_username) rescue []
    reviews = MalImport.fetch_reviews_from_remote(mal_username) rescue []

    staged_import.data = {
      version: 1, 
      watchlist: watchlist, 
      reviews: reviews, 
      complete: true
    }

    staged_import.save    

    if apply
      MALImportApplyWorker.perform_async(staged_import.user.id)
    end
  end
end
