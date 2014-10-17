class Blotter
  BLOTTER_KEY = "blotter"

  def self.set(opts)
    $redis.with do |conn|
      conn.set(BLOTTER_KEY, {
        icon: 'fa-exclamation-circle'
      }.merge(opts).compact.to_json)
    end
  end

  def self.get
    JSON.parse($redis.with {|conn| conn.get(BLOTTER_KEY) })
  rescue
    nil
  end

  def self.clear
    $redis.with {|conn| conn.del(BLOTTER_KEY) }
  end
end
