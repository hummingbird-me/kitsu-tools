require 'test_helper'
require 'onebox/engine/hummingbird_onebox'

class HummingbirdOneboxTest < ActiveSupport::TestCase
  test "supports media links" do
    [ "https://hummingbird.me/anime/sword-art-online",
      "https://hummingbird.me/a/sword-art-online",
      "https://hummingbird.me/manga/monster",
      "https://hummingbird.me/m/monster"
    ].each do |media|
      html = Onebox.preview(media).to_s
      doc = Nokogiri::HTML.parse(html)
      assert_equal 2, doc.css('a').count
      assert_equal 1, doc.css('img').count
    end
  end

  test "returns a link when media isn't found" do
    assert_match /\A<a/, Onebox.preview("https://hummingbird.me/anime/this-is-fake").to_s
  end
end
