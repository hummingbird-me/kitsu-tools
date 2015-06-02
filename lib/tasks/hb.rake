namespace :hummingbird do
  desc 'Download images from Hummingbird for better development'
  task images: %w(images:posters images:covers)

  namespace :images do
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
      Anime.order_by_rating.limit(quantity).each do |anime|
        path = anime.send(type).path
        if path && File.exist?(path)
          puts "#{anime.title} - \033[32mImage already downloaded\033[0m"
          next
        end

        puts "#{anime.title} - \033[31mNo image found, downloading…\033[0m"

        remote_url = open(
          "https://hummingbird.me/full_anime/#{anime.slug}.json",
          ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE
        ).read
        remote_anime = JSON.parse(remote_url)['full_anime']

        anime.update_from_pending(
          anime.create_pending(
            User.first,
            type => remote_anime[type.to_s],
            edit_comment: 'Rake automatic image download'
          )
        )
      end
    end
  end
end
