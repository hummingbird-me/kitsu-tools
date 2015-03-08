class TrendingGroups
  STREAM_KEY = "trending_groups"
  HALF_LIFE  = 7.days.to_i
  EPOCH      = Date.new(2020, 1, 1).to_time.to_i

  def self.vote(group_id)
    $redis.with do |conn|
      conn.zincrby STREAM_KEY, 2.0**((Time.now.to_i - EPOCH) / HALF_LIFE), group_id
    end
    trim(STREAM_KEY, 500) if rand < 0.1
  end

  def self.get(page: 1, per: 10)
    $redis.with do |conn|
      conn.zrevrange(STREAM_KEY, (page - 1) * per, (page * per) - 1).map {|x| x.to_i }
    end
  end

  def self.trim(key, n)
    $redis.with {|conn| conn.zremrangebyrank(key, 0, -n) }
  end

  def self.list(page: 1, per: 10)
    ids = get(page: page, per: per)
    Group.find(ids).index_by(&:id).slice(*ids).values
  end
end
