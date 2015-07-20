namespace :hummingbird do
  desc 'Download images from Hummingbird for better development'
  task images: %w(images:anime_posters images:anime_covers images:manga_posters
    images:manga_covers)

  namespace :images do

    desc 'Download only anime images'
    task anime: %w(images:anime_posters images:anime_covers)
    desc 'Download only manga images'
    task manga: %w(images:manga_posters images:manga_covers)

    desc 'Download only anime posters'
    task :anime_posters, [:quantity] => [:environment] do |_t, args|
      args.with_defaults(quantity: 72)
      puts "\n\033[32m=> Checking anime posters\033[0m\n"
      get_image(:anime, args.quantity, :poster_image)
    end

    desc 'Download only anime covers'
    task :anime_covers, [:quantity] => [:environment] do |_t, args|
      args.with_defaults(quantity: 72)
      puts "\n\033[32m=> Checking anime covers\033[0m\n"
      get_image(:anime, args.quantity, :cover_image)
    end

    desc 'Download only manga posters'
    task :manga_posters, [:quantity] => [:environment] do |_t, args|
      args.with_defaults(quantity: 72)
      puts "\n\033[32m=> Checking manga posters\033[0m\n"
      get_image(:manga, args.quantity, :poster_image)
    end

    desc 'Download only manga covers'
    task :manga_covers, [:quantity] => [:environment] do |_t, args|
      args.with_defaults(quantity: 72)
      puts "\n\033[32m=> Checking manga covers\033[0m\n"
      get_image(:manga, args.quantity, :cover_image)
    end

    def get_image(media_type, qty, type = :poster_image)
      klass = media_type.to_s.camelize.constantize
      klass.order_by_rating.limit(qty).each do |media|
        path = media.send(type).path
        title = media.try(:title) || media.try(:romaji_title)
        if path && File.exist?(path)
          puts "#{title} - \033[32mImage already downloaded\033[0m"
          next
        end

        puts "#{title} - \033[31mNo image found, downloading…\033[0m"

        remote_url = open(
          "https://hummingbird.me/full_#{media_type}/#{media.slug}.json"
        ).read
        remote_media = JSON.parse(remote_url)["full_#{media_type}"]

        media.update_attributes(type => remote_media[type.to_s])

      end
    end
  end
end
