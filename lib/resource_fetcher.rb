require 'open-uri'

class ResourceFetcher
  def initialize(url)
    @url = url
  end

  def get
    url = "http://api.phantomjscloud.com/single/browser/v1/ed7bc1b60d7f2629d05c133c06b8fa8b135d0839/%7B%22targetUrl%22%3A%22#{Rack::Utils.escape(@url)}%22%2C%22requestType%22%3A%22raw%22%2C%22outputAsJson%22%3Afalse%2C%22loadImages%22%3Afalse%2C%22isDebug%22%3Afalse%2C%20%22timeout%22%3A15000%2C%20%22postDomLoadedTimeout%22%3A10000%2C%20%22userAgent%22%3A%22Mozilla%2F5.0%20%28iPad%3B%20U%3B%20CPU%20OS%203_2_1%20like%20Mac%20OS%20X%3B%20en-us%29%20AppleWebKit%2F531.21.10%20%28KHTML%2C%20like%20Gecko%29%20Mobile%2F7B405%22%2C%20%22resourceUrlBlacklist%22%3A%5B%22.*tribalfusion.*%22%2C%20%22.*doubleclick.*%22%2C%20%22.*googlead.*%22%2C%20%22.*triggertag.*%22%5D%7D"
    open(url).read
  end
end
