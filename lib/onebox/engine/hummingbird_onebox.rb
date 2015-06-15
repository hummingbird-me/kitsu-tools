module Onebox
  module Engine
    class HummingbirdOnebox
      include Engine

      matches_regexp /https?:\/\/(?:www\.)?hummingbird\.me\/(?<type>anime|manga)\/(?<slug>.+)/

      def to_html
        return "<a href=\"#{@url}\">#{@url}</a>" if media.nil?
        <<-HTML
          <div class="onebox">
            <div class="source">
              <div class="info">
                <a href="#{@url}" class="track-link" target="_blank">
                  #{media.class.to_s} (#{media_type})
                </a>
              </div>
            </div>
            <div class="onebox-body media-embed">
              <img src="#{media.poster_image.url(:large)}" class="thumbnail">
              <h3><a href="#{@url}" target="_blank">#{media.canonical_title}</a></h3>
              <h4>#{media.genres.map {|x| x.name }.sort * ", "}</h4>
              #{media.synopsis[0..199]}...
            </div>
            <div class="clearfix"></div>
          </div>
        HTML
      end

      private

      def type
        @@matcher.match(@url)["type"]
      end

      def slug
        @@matcher.match(@url)["slug"]
      end

      def media
        @_media ||= type.classify.constantize.find(slug)
      rescue
        nil
      end

      def media_type
        if media.is_a?(Anime)
          media.show_type
        elsif media.is_a?(Manga)
          media.manga_type
        end
      end

      def uri
        @_uri ||= URI(@url)
      end
    end
  end
end
