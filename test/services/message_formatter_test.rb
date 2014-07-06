require 'test_helper'
require 'fakeweb_helper'

fake({
  [:get, "http://i.imgur.com/CUjJQap.gif"] => "small_image",
  [:get, "https://i.minus.com/iE02xvicOlrbF.gif"] => "large_image"
})

class MessageFormatterTest < ActiveSupport::TestCase
  def format(message)
    MessageFormatter.format_message(message)
  end

  test "links to URLs" do
    assert_match /href=/, format("http://vikhyat.net/")
  end

  test "replaces newlines with <br>" do
    assert_match /a<br\s?\/?>b/, format("a\nb")
    assert_match /a(<br\s?\/?>){2}b/, format("a\n\n\nb") # max two <br>s
  end

  test "embeds small images" do
    assert_match /img/, format("http://i.imgur.com/CUjJQap.gif")
  end

  test "does not embed large images" do
    assert_no_match /img/, format("https://i.minus.com/iE02xvicOlrbF.gif")
  end

  test "embeds youtube videos" do
    assert_match /iframe/, format("https://www.youtube.com/watch?v=v8YEw6JaM3c")
  end

  test "removes original embedded link URL" do
    fmt = format("message http://i.imgur.com/CUjJQap.gif")
    noko = Nokogiri::HTML.parse fmt
    assert_match /message/, fmt
    assert_equal 1, noko.css('a').length
  end

  test "links usernames" do
    assert_match /href=/, format("@vikhyat")
  end

  test "no <br> for image-only posts" do
    assert_no_match /br/, format("http://i.imgur.com/CUjJQap.gif")
  end
end
