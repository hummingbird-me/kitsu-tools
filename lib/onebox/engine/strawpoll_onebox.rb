module Onebox
  module Engine
    class StrawpollOnebox
      include Engine

      matches_regexp /^https?:?\/\/(?:www\.)?(?:strawpoll.me)\/(?<poll>.+)$/

      def poll_id
        @poll ||= @@matcher.match(@url)["poll"]
      end

      def to_html
        if poll_id
          "<iframe src=\"https://strawpoll.me/embed_1/#{poll_id}\"></iframe>"
        else
          "<a href=\"#{@url}\">#{@url}</a>"
        end
      end

      private

      def uri
        @_uri ||= URI(@url)
      end
    end
  end
end
