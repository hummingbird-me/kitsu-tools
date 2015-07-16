class MyAnimeListImportApplyWorker
  include Sidekiq::Worker
  # TODO: actually fix the bug
  sidekiq_options retry: 3
  sidekiq_retry_in do |count|
    10.minutes * (count + 1)
  end

  def perform(user_id, xml)
    user = User.find(user_id)
    malimport = MyAnimeListImport.new(user, xml)
    malimport.apply!
    user.recompute_life_spent_on_anime!
    user.update_columns import_status: nil, import_from: nil, import_error: nil
  rescue Exception
    status = User.import_statuses[:error]
    user.update_columns import_status: status,
      import_error: 'There was a problem importing your list.  Please send an
                     email to josh@hummingbird.me with the file you are trying
                     to import and we\'ll see what we can do.'
    raise
  end
end
