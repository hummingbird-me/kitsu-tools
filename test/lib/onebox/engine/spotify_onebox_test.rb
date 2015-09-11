require 'test_helper'
require 'onebox/engine/spotify_onebox'

class SpotifyOneboxTest < ActiveSupport::TestCase
  setup do
    fake_requests({
      [:get, "https?://open.spotify.com/user/hardwellofficial/playlist/5Vk6tmchGfGYIYp7ubXI6i"] => "spotify_playlist",
      [:get, "https://embed.spotify.com/oembed/\\?url=https?://open.spotify.com/user/hardwellofficial/playlist/5Vk6tmchGfGYIYp7ubXI6i"] => "spotify_oembed"
    })
  end

  test "embeds the spotify player" do
    assert_match /iframe/, Onebox.preview("http://open.spotify.com/user/hardwellofficial/playlist/5Vk6tmchGfGYIYp7ubXI6i").to_s
    assert_match /iframe/, Onebox.preview("https://open.spotify.com/user/hardwellofficial/playlist/5Vk6tmchGfGYIYp7ubXI6i").to_s
  end
end
