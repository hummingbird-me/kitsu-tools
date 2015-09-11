require 'test_helper'
require 'onebox/engine/twitch_onebox'

class TwitchOneboxTest < ActiveSupport::TestCase
  setup do
    fake_requests({
      [:get, "https?://(?:www\\.)?twitch.tv/lirik"] => "twitch_channel"
    })
  end

  test "supports multiple URL types" do
    assert_match /iframe/, Onebox.preview("https://twitch.tv/lirik").to_s
    assert_match /iframe/, Onebox.preview("http://www.twitch.tv/lirik").to_s
  end

  test "embeds the twitch player with autoplay set to false" do
    data = Onebox.preview("https://twitch.tv/lirik").to_s
    assert_match /iframe/, data
    assert_match /&auto_play=false/, data
  end
end
