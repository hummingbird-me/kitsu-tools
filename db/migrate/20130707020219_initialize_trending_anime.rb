class InitializeTrendingAnime < ActiveRecord::Migration
  def up
    epoch = Date.new(2020, 1, 1).to_time.to_i
    half_life = 7.days.to_i
    $redis.del "trending_anime"
    Watchlist.order("updated_at DESC").limit(50000).each do |w|
      $redis.zincrby "trending_anime", 2.0**((w.updated_at.to_i - epoch)/half_life), w.anime_id
    end
  end

  def down
  end
end
