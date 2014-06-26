class TrendingAnime
  STREAM_KEY = "trending_anime"
  HALF_LIFE  = 7.days.to_i
  EPOCH      = Date.new(2020, 1, 1).to_time.to_i
  
  def self.vote(anime_id)
    $redis.zincrby STREAM_KEY, 2.0**((Time.now.to_i - EPOCH) / HALF_LIFE), anime_id
    trim(STREAM_KEY, 10000) if rand < 0.1
  end
  
  def self.get(limit=5)
    $redis.zrevrange(STREAM_KEY, 0, limit-1).map {|x| x.to_i }
  end
  
  def self.trim(key, n)
    $redis.zremrangebyrank(key, 0, -n)
  end

  def self.list(count = 5)
    Anime.find(get(count))
  end
end
