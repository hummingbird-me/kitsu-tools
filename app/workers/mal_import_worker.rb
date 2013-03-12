require 'nokogiri'
require 'open-uri'

class MALImportWorker
  include Sidekiq::Worker

  def perform(mal_username, staged_import_id)
    staged_import = StagedImport.find(staged_import_id)
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
  end
end
