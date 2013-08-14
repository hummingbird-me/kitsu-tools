class InitializeAnimeRatingFrequencies < ActiveRecord::Migration
  def up
    Anime.find_each do |anime|
      anime.rating_frequencies = {}
      anime.watchlists.where('rating IS NOT NULL').find_each do |watchlist|
        if watchlist.rating
          rating = (watchlist.rating * 2).round / 2.0
          anime.rating_frequencies[rating] ||= 0
          anime.rating_frequencies[rating] += 1
        end
      end
      anime.save
      STDERR.puts "Finished #{anime.title} (#{anime.id})"
    end
  end

  def down
    Anime.find_each do |anime|
      anime.rating_frequencies = {}
      anime.save
    end
  end
end
