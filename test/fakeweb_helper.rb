require 'fakeweb'

FakeWeb.allow_net_connect = %r[^https?://codeclimate.com/]

def fake(routes)
  routes.map { |k, v|
    # Ghetto globbing
    if k[1].is_a?(String)
      k[1].gsub!("*", "[^/]*")
      k[1] = Regexp.new("^#{k[1]}$")
    end
    [k, v]
  }.each do |url, filename|
    file = File.join("test", "fixtures", "fakeweb", "#{filename}.response")
    FakeWeb.register_uri(url[0], url[1], :response => file)
  end
end
