namespace :importers do
  desc 'Import the bcmoe.json file from disk or (by default) off because.moe'
  task :bcmoe, [:filename] => [:environment] do |t, args|
    # Load the JSON
    json_file = open(args[:filename] || 'http://because.moe/bcmoe.json').read
    bcmoe = JSON.parse(json_file).map(&:deep_symbolize_keys)

    # Create the streamers
    puts '=> Creating Streamers'
    sites = bcmoe.map { |x| x[:sites].keys }.flatten.uniq
    sites = sites.map do |site|
      puts site
      [site, Streamer.where(site_name: site.to_s.titleize).first_or_create]
    end
    sites = Hash[sites]

    # Load the data
    puts '=> Loading Data'
    Chewy.strategy(:atomic) do
      bcmoe.each do |show|
        result = Anime.fuzzy_find(show[:name])

        # Shit results?  Let humans handle it!
        if result.nil? || result._score <= 2
          next puts("      #{show[:name]} => #{show[:sites]}")
        end

        anime = result._object
        confidence = [result._score, 5].min.floor
        # Handle Spanish Hulu bullshit
        spanish = show[:name].include?('(Espa')
        dubs = spanish ? %w[es] : %w[ja]
        subs = spanish ? %w[es] : %w[en]

        # Output confidence and title mapping
        print (' ' * confidence) + ('*' * (5 - confidence)) + ' '
        puts "#{show[:name]} => #{anime.canonical_title}"

        # Create StreamingLink for each site listed
        show[:sites].each do |site, url|
          link = StreamingLink.where(
            streamer: sites[site],
            url: url,
            media: anime
          ).dubbed(dubs).subbed(subs).first_or_create(dubs: dubs, subs: subs)
        end
      end
    end
  end
end
