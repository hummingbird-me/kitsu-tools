desc "Bulk import videos from Hulu"
task :bulk_import_hulu, [:shows] => [:environment] do |t, args|
  require 'hooloo'
  require 'rubyfish'

  @results = {
    fail: 0
  }
  def import_episodes(anime, show, how=nil, uncertain=false)
    @results[how] = 0 unless @results.has_key?(how)
    @results[how] += 1

    printf "%s --> %s\n", show.name, [anime.title, anime.alt_title].compact.delete_if(&:empty?).join(', ')

    show.videos.each do |video|
      next unless video.video_type == 'episode'
      episode = Episode.create_or_update_from_hash({
        anime: anime,
        episode: video.episode_number,
        season: video.season_number,
        title: video.title.gsub(/^([sd]ub) /i, '').strip,
        synopsis: video.description,
        thumbnail: video.thumbnail_url
      })
      # I know it could be better but it'll work for now
      dubs = 'EN'
      dubs = 'JP' if begin video.categories.include?('Subtitled') rescue false end
      dubs = 'JP' if video.title.include?('(sub)')
      dubs = 'ES' if show.name.include?('(Español)')
      Video.create_or_update_from_hash({
        streamer: @streamer,
        episode: episode,
        url: "http://www.hulu.com/watch/#{video.id}",
        embed_data: { embed_url: video.oembed['embed_url'] }.to_json,
        available_regions: ['US'],
        sub_lang: video.closed_captions.join(',').upcase,
        dub_lang: dubs
      })
      print '.'
    end
    print "\n"
    $stderr.printf "???? %s --> %s (via %s)\n", show.name, [anime.title, anime.alt_title].compact.delete_if(&:empty?).join(', '), how.to_s if uncertain
  rescue
    $stderr.puts "Something went wrong."
  end
  def best_magic(options, min_or_max, &block)
    sorted = options.compact.map do |anime|
      {
        anime: anime,
        sort: [
          block.try(:call, anime.title.try(:downcase) || ''),
          block.try(:call, anime.alt_title.try(:downcase) || '')
        ].compact.reject{ |a| a.try(:nan?) || false }.send(min_or_max)
      }
    end.sort { |a, b| a[:sort] <=> b[:sort] }
    if min_or_max == :min
      sorted
    else
      sorted.reverse
    end.first
  end

  puts '==> Creating streamer entry'
  @streamer = Streamer.where(
    site_name: 'Hulu'
  ).first_or_create


  puts '==> Loading anime from Hulu'
  shows = Hooloo::Genre.new('anime').shows
  shows = shows.first(args[:shows].to_i) unless args[:shows].nil?

  puts '==> Attempting to match shows'
  shows.each do |show|
    options = []
    ## Exact Match
    options << anime = Anime.where("lower(title) = :title OR lower(alt_title) = :title",
                                   title: show.name.downcase).first
    next import_episodes(anime, show, :exact) unless anime.nil?

    ## Trigram
    options << anime = Anime.fuzzy_search_by_title(show.name).first
    next import_episodes(anime, show, :trigram, anime.pg_search_rank < 0.75) if !anime.nil? && anime.pg_search_rank > 0.66

    ## Prefix
    options << anime = Anime.where("lower(title) SIMILAR TO :prefix OR lower(alt_title) SIMILAR TO :prefix",
                                   prefix: "#{show.name.downcase}(:| ) %").first
    next import_episodes(anime, show, :prefix, true) unless anime.nil?

    ## Damerau-Levenshtein Distance
    best = best_magic(options, :min) { |title| RubyFish::DamerauLevenshtein.distance(title, show.name.downcase) }
    next import_episodes(best[:anime], show, :levenshtein, best[:sort] > 1) if best[:sort] < 3

    # Longest Common Subsequence
    best = best_magic(options, :max) { |title| RubyFish::LongestSubsequence.distance(title, show.name.downcase).to_f / (title.length + show.name.length) }
    next import_episodes(best[:anime], show, :subsequence, best[:sort] < 0.4) if best[:sort] > 0.33

    $stderr.printf "----  %s ---> %s\n", show.name, options.compact.map{ |a| [a.title, a.alt_title] }.compact.flatten.join(', ')
    @results[:fail] += 1
  end
  puts "====== Of %d =======" % @results.values.reduce(:+)
  @results.each do |how, num|
    puts "%s: %d" % [how.to_s, num]
  end
=begin
=end
end
