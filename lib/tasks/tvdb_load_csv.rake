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
    $stderr.puts "HUMANPLS #{Hash[row].to_json}" if row['tvdb_season_id'].try(:downcase) == 'nuck'
    begin
      Anime.update(row['id'], {
        thetvdb_series_id: row['tvdb_series_id'],
        thetvdb_season_id: row['tvdb_season_id'].try(:downcase)
      })
    rescue Exception => e
      $stderr.printf "ERROR: [%s] %s\n", row['title'], e.to_s
    end
  end
end
