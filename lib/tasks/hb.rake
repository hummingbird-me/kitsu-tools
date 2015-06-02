namespace :hummingbird do
  desc 'Download images from Hummingbird for better development'
  task images: 'images:anime'

  namespace :images do
    desc 'Download anime cover images, to test listings'
    task :anime, [:quantity] => [:environment] do |_t, args|
      args.with_defaults(quantity: 72)
      Anime.order_by_rating.limit(args.quantity).each do |anime|
        print anime.title

        if File.exist? anime.cover_image.path
          puts " - \033[32mImage already downloaded\033[0m"
          next
        end

        puts " - \033[31mNo image found, starting download…\033[0m"

        remote_url = open(
          "https://hummingbird.me/full_anime/#{anime.slug}.json",
          ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE
        ).read
        remote_anime = JSON.parse(remote_url)['full_anime']

        anime.update_from_pending(
          anime.create_pending(
            User.first,
            cover_image: remote_anime['cover_image'],
            poster_image: remote_anime['poster_image'],
            edit_comment: 'Rake automatic image download'
          )
        )
      end
    end
  end
end
