WebMock.disable_net_connect!(allow: %w[codeclimate.com robohash.org])

class ActiveSupport::TestCase
  def fake_requests(routes)
    routes.map { |k, v|
      # Ghetto globbing
      if k[1].is_a?(String)
        k[1].gsub!("*", "[^/]*")
        k[1] = Regexp.new("^#{k[1]}$")
      end
      [k, v]
    }.each do |url, filename|
      file = File.open(File.join("test", "fixtures", "webmock", "#{filename}.response"))
      stub_request(url[0], url[1]).to_return(file)
    end
  end
  alias_method :fake_request, :fake_requests
end
