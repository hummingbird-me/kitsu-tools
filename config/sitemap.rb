# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://hummingbird.me"

SitemapGenerator::Sitemap.create do
  # Users
  User.find_each do |user|
    add user_path(user), lastmod: user.updated_at
  end

  # Anime
  add '/anime'
  Anime.find_each do |anime|
    add anime_path(anime), lastmod: anime.updated_at
    add anime_quotes_path(anime), lastmod: anime.quotes.map {|x| x.updated_at }.max

    # Reviews
    anime.reviews.each do |review|
      add anime_review_path(anime, review), lastmod: review.updated_at
    end
  end
end
