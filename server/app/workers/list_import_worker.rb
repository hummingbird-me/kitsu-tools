class ListImportWorker
  include Sidekiq::Worker

  def perform(import_id)
    import = ListImport.find(import_id)
    import.apply!
  end
end
