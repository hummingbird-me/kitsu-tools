Onebox::Engine::WhitelistedGenericOnebox.whitelist.delete('twitch.tv')
module Onebox
  module Engine
    class TwitchOnebox
      include Engine
      include StandardEmbed

      matches_regexp /^https?:?\/\/(?:www\.)?(?:twitch\.tv)\/.+$/

      def to_html
        video_url = raw.metadata[:'video:secure_url'].first
        "<iframe src=\"#{video_url}&auto_play=false\" frameborder=\"0\" title=\"#{raw.title}\"></iframe>"
      end
    end
  end
end
