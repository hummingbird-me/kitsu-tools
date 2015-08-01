module ActiveSupport
  class TestCase
    def fake_requests(routes)
      routes_mapped = routes.map do |k, v|
        # Ghetto globbing
        if k[1].is_a? String
          k[1].gsub!('*', '[^/]*')
          k[1] = Regexp.new("^#{k[1]}$")
        end
        [k, v]
      end
      routes_mapped.each do |url, filename|
        file = File.open("test/fixtures/webmock/#{filename}.response")
        stub_request(url[0], url[1]).to_return(file)
      end
    end
    alias_method :fake_request, :fake_requests
  end
end
