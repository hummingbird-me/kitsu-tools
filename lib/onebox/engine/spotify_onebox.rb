# Spotify has since changed their oEmbed API to require a User-Agent to be sent
Onebox::Engine::WhitelistedGenericOnebox.whitelist.delete('spotify.com')
module Onebox
  module Engine
    class SpotifyOnebox
      include Engine

      matches_regexp /^https?:?\/\/(?:open\.)?(?:spotify\.com)\/.+$/

      def http_params
        { 'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2503.0 Safari/537.36' }
      end

      def raw
        return @raw if @raw
        fetch_oembed_raw("https://embed.spotify.com/oembed/?url=#{@url}")
        @raw if @raw
      end

      def to_html
        raw[:html] unless raw.nil? || raw[:html].nil?
      end

      private

      def fetch_oembed_raw(oembed_url)
        @raw = Onebox::Helpers.symbolize_keys(::MultiJson.load(Onebox::Helpers.fetch_response(oembed_url, 5, nil, http_params).body))
      rescue Errno::ECONNREFUSED, Net::HTTPError, MultiJson::LoadError
        @raw = nil
      end
    end
  end
end
