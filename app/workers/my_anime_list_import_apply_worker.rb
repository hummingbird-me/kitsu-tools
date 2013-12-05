class MyAnimeListImportApplyWorker
  include Sidekiq::Worker

  def perform(user_id, xml)
    user = User.find(user_id)
    malimport = MyAnimeListImport.new(user, xml)
    malimport.apply!
    user.update_column :mal_import_in_progress, false
  end
end
