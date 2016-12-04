require 'test_helper'
require 'webmock_helper'

class MessageFormatterTest < ActiveSupport::TestCase
  def format(message)
    MessageFormatter.format_message(message)
  end

  test "links to URLs" do
    assert_match /href=/, format("http://vikhyat.net/")
  end

  test "does not link emails" do
    assert_no_match /href=/, format("Idolm@ster. Literally.")
  end

  test "replaces newlines with <br>" do
    assert_match /a<br\s?\/?>b/, format("a\nb")
    assert_match /a(<br\s?\/?>){2}b/, format("a\n\n\nb") # max two <br>s
  end

  test "embeds images under 2mb" do
    fake_request [:get, "http://i.imgur.com/CUjJQap.gif"] => "small_image"
    assert_match /img/, format("http://i.imgur.com/CUjJQap.gif")
  end

  test "does not embed images over 2mb" do
    fake_request [:get, "https://i.minus.com/iE02xvicOlrbF.gif"] => "large_image"
    assert_no_match /img/, format("https://i.minus.com/iE02xvicOlrbF.gif")
  end

  test "removes original embedded link URL" do
    fake_request [:get, "http://i.imgur.com/CUjJQap.gif"] => "small_image"
    fmt = format("message http://i.imgur.com/CUjJQap.gif")
    noko = Nokogiri::HTML.parse fmt
    assert_match /message/, fmt
    assert_equal 1, noko.css('a').length
  end

  test "links usernames" do
    assert_match /href=/, format("@vikhyat")
    assert_match /href=/, format("@Vikhyat")
  end

  test "doesn't remove links that are not embedded" do
    fake_request [:get, "http://i.imgur.com/CUjJQap.gif"] => "small_image"
    fmt = format("http://vikhyat.net http://i.imgur.com/CUjJQap.gif")
    noko = Nokogiri::HTML.parse fmt
    assert_equal 2, noko.css('a').length
  end

  test "no <br> for image-only posts" do
    fake_request [:get, "http://i.imgur.com/CUjJQap.gif"] => "small_image"
    assert_no_match /br/, format("http://i.imgur.com/CUjJQap.gif")
  end

  test "avoid three <br>s in a row for images" do
    fake_request [:get, "http://i.imgur.com/CUjJQap.gif"] => "small_image"
    assert_equal 2, format("a\n\nhttp://i.imgur.com/CUjJQap.gif").scan("br").count
  end

  test 'extract all @mentions from a post' do
    mentions = MessageFormatter.extract_mentions('@vikhyat @josh')
    assert_equal 2, mentions.count
    mentions.each do |m|
      assert_instance_of User, m
    end
  end
end
