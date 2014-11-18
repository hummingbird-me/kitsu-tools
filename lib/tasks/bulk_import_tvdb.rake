# This file is basically one big disaster
# I look forward to the day we delete it
desc "Bulk import info from TVDB"
task :bulk_import_tvdb, [] => [:environment] do |t, args|
  require 'parallel'

  ActiveRecord::Base.connection_pool.disconnect!
  config = ActiveRecord::Base.configurations[Rails.env]
  config['pool'] = 16
  ActiveRecord::Base.establish_connection(config)

  # This fixes some threaded autoloading issues
  Episode

  $results = {
    failure: 0,
    success: 0,
    skipped: 0
  }

  KEY = '21F012C4F48D4288'
  def tvdb(path)
    begin
      hash = Hash.from_xml(open("http://thetvdb.com/api/#{KEY}/#{path}"))
      hash.deep_transform_keys! { |k| k.to_s.underscore.to_sym }
      hash[:data]
    rescue
      $stderr.puts "404: http://thetvdb.com/api/#{KEY}/#{path}"
      return nil
    end
  end
  def tvdb_series(id, lang='en')
    tvdb("series/#{id}/all/#{lang}.xml")
  end
  def failed(title, msg="")
    $stderr.puts "Failed: [#{title}] #{msg}"
    $results[:failure] += 1
  end
  def skipped
    $results[:skipped] += 1
  end

  shows = Anime.select(:id, :title, :thetvdb_series_id, :thetvdb_season_id, :episode_count)
               .where.not(thetvdb_series_id: "")

  Parallel.each(shows, in_threads: 8, progress: 'Importing') do |anime|
    begin
      next skipped if anime.thetvdb_series_id == "-1"
      tvdb_anime = tvdb_series(anime.thetvdb_series_id)
      tvdb_anime_jp = tvdb_series(anime.thetvdb_series_id, 'ja') || {}
      season_id = anime.thetvdb_season_id
      next failed(anime.title, "404 Error for SeriesID=#{anime.thetvdb_series_id}") if tvdb_anime.nil?
      next skipped if season_id.try(:downcase) == 'nuck'
      next failed(anime.title, "No episodes found for SeriesID=#{anime.thetvdb_series_id}") if tvdb_anime[:episode].blank?

      anime.update_column :jp_title, tvdb_anime_jp[:series][:series_name] unless tvdb_anime_jp[:series][:series_name] == tvdb_anime[:series][:series_name]

      tvdb_season = tvdb_anime[:episode].select do |ep|
        if ep.is_a? Hash
          if season_id != ''
            season_id == ep[:seasonid]
          else
            ep[:season_number].to_i >= 1
          end
        end
      end
      if tvdb_season.count == 0
        tvdb_season = tvdb_anime[:episode]
      end

      jp_titles = Hash[tvdb_anime_jp[:episode].map { |ep| [ep[:id], ep[:episode_name]] if ep.is_a? Hash }]

      # We don't wanna fuck with the episode count too much
      if ((anime.episode_count || 0) - tvdb_season.count).abs > 5 && anime.episode_count != 0 && anime.thetvdb_season_id != 'ALL'
        # If the numbers don't seem to line up, try just the first season
        tvdb_season = tvdb_season.select { |ep| ep[:season_number].to_i == 1 }
        # We give less of a margin on a single season
        if ((anime.episode_count || 0) - tvdb_season.count).abs > 2
          $stderr.printf "Mismatched (%d != %d): %s (SeriesID=%s, SeasonID=%s)\n",
            (anime.episode_count || 0), (tvdb_season.count || 0), anime.title,
            anime.thetvdb_series_id, anime.thetvdb_season_id
          $results[:failure] += 1
          next
        end
      end

      # truncate if we're not doing ALL or have 0/nil episodes
      tvdb_season = tvdb_season[0..anime.episode_count] if season_id != 'ALL' || anime.episode_count != 0 || !anime.episode_count.nil?
      next $stderr.printf "Nil season: %s (SeriesID=%s, SeasonID=%s)\n", anime.title, anime.thetvdb_series_id, anime.thetvdb_season_id if tvdb_season.nil?
      tvdb_season.each do |ep|
        thumb_url = URI("http://thetvdb.com/banners/#{ep[:filename]}")
        thumb_type = Net::HTTP.start(thumb_url.host, thumb_url.port).head(thumb_url)['Content-Type']
        jp_title = jp_titles[ep[:id]]
        Episode.create_or_update_from_hash({
          anime: anime,
          episode: ep[:episode_number],
          airdate: ep[:first_aired],
          season: ep[:season_number] || 1,
          title: ep[:episode_name],
          jp_title: (jp_title unless ep[:episode_name] == jp_title),
          synopsis: ep[:overview],
          thumbnail: (thumb_url if thumb_type.starts_with? 'image/')
        })
      end
      $results[:success] += 1
    rescue Exception => e
      $stderr.puts "ERROR: #{e}\n  #{e.backtrace.join("\n  ")}"
    end
  end
  $stderr.printf "Success: %d, Failure: %d, Skipped: %d\n", $results[:success], $results[:failure], $results[:skipped]
end
