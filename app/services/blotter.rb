class Blotter
  BLOTTER_KEY = "blotter"

  def self.set(opts)
    $redis.set(BLOTTER_KEY, {
      icon: 'fa-exclamation-circle'
    }.merge(opts).compact.to_json)
  end
  def self.get
    JSON.parse($redis.get(BLOTTER_KEY))
  rescue
    nil
  end
  def self.clear
    $redis.del(BLOTTER_KEY)
  end
end
