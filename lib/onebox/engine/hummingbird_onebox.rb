module Onebox
  module Engine
    class HummingbirdOnebox
      include Engine
      include JSON

      matches_regexp /https?:\/\/(?:www\.)?hummingbird\.me\/anime\/.+/

      def url
        slug = @url.match(/https?:\/\/(?:www\.)?hummingbird\.me\/anime\/(.+)/)[1]
        "https://hummingbird.me/api/v1/anime/#{slug}"
      end

      def to_html
        anime = raw
        "
        <div class='onebox'>
          <div class='source'>
            <div class='info'>
              <a href='#{@url}' class='track-link' target='_blank'>
                Anime (#{anime["show_type"]})
              </a>
            </div>
          </div>
          <div class='onebox-body anime-embed'>
            <img src='#{anime["cover_image"]}' class='thumbnail'>
            <h4><a href='#{@url}' target='_blank'>#{anime["title"]}</a></h4>
            <h4>#{anime["genres"].map {|x| x["name"] } * ", "}</h4>
            #{anime["synopsis"][0..199]}...
          </div>
          <div class='clearfix'></div>
        </div>
        "
      end
    end
  end
end
