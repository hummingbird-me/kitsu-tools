desc "Load a CSV of TVDB IDs into the database"
task :tvdb_load_csv, [:file] => [:environment] do |t, args|
  csv = CSV.foreach(args[:file], headers: true)

  ActiveRecord::Base.connection_pool.disconnect!
  config = ActiveRecord::Base.configurations[Rails.env]
  config['pool'] = 16
  ActiveRecord::Base.establish_connection(config)

  # This fixes some threaded autoloading issues
  Episode
  Anime

  Parallel.each(csv, in_threads: 8, progress: 'Loading CSV') do |row|
    next if row['tvdb_series_id'].nil? || row['tvdb_series_id'] == -1
    begin
      anime = Anime.find(row['id'])
      anime.thetvdb_series_id = row['tvdb_series_id'] || ''
      anime.thetvdb_season_id = row['tvdb_season_id'] || ''
      anime.save!
    rescue Exception => e
      $stderr.printf "ERROR: %s\n%s\n\n", anime.try(:title), e.to_s
    end
  end
end
