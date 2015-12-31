namespace :importers do
  namespace :hummingbird do
    desc 'Download only anime posters'
    task :posters, [:quantity] => [:environment] do |_t, args|
      args.with_defaults(quantity: 72)
      puts "\n\033[32m=> Checking anime posters\033[0m\n"
      get_anime_image(args.quantity, :poster_image)
    end

    desc 'Download only anime covers'
    task :covers, [:quantity] => [:environment] do |_t, args|
      args.with_defaults(quantity: 72)
      puts "\n\033[32m=> Checking anime covers\033[0m\n"
      get_anime_image(args.quantity, :cover_image)
    end

    def get_anime_image(quantity, type = :poster_image)
      Chewy.strategy(:bypass) do
        Anime.order(user_count: :desc).limit(quantity).each do |anime|
          path = anime.send(type).path
          if path && File.exist?(path)
            puts "#{anime.canonical_title} - \033[32mImage already downloaded\033[0m"
            next
          end

          puts "#{anime.canonical_title} - \033[31mNo image found, downloading…\033[0m"

          remote_url = open(
            "https://hummingbird.me/full_anime/#{anime.slug}.json"
          ).read
          remote_anime = JSON.parse(remote_url)['full_anime']

          anime.update_attributes(type => remote_anime[type.to_s])
        end
      end
    end
  end

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
