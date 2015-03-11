require 'timeout'
require 'onebox'

class MessageFormatter

  def initialize(message)
    @message = message
    @processed = message

    # apply filters
    autolink
    link_usernames
    process_newlines
    embed_media
    embed_emoji
    spoilers
  end

  def format
    @processed
  end

  def self.format_message(message)
    MessageFormatter.new(message).format
  end

  private

  def autolink
    @processed = Rinku.auto_link(ERB::Util.html_escape(@processed), :urls, 'target="_blank"')
  end

  def link_usernames
    @processed.gsub!(/@[_A-Za-z0-9]+/) do |x|
      if user = User.find_by_username(x[1..-1])
        "<a href='//hummingbird.me/users/#{user.name}' target='_blank' data-user-name='#{user.name}' class='name'>@#{user.name}</a>"
      else
        x
      end
    end
  end

  def process_newlines
    @processed.gsub!(/\n{3,}/, "\n\n")
    @processed.gsub!(/\n/, "<br>")
  end

  def embed_media
    # Next verson of onebox will have gfycat support by default.
    Onebox::Engine::WhitelistedGenericOnebox.whitelist << "gfycat.com"

    html = Nokogiri::HTML.fragment(@processed)

    html.css("a").each do |a|
      href = a["href"]
      next if href =~ IMAGE_REGEX && filesize(href) > MAX_IMAGE_FILE_SIZE
      preview = Onebox.preview(href, max_width: 500) rescue nil
      a.swap(Nokogiri::HTML.fragment(preview.to_s)) if preview.try(:to_s).present?
    end

    @processed = html.to_s
  end

  def embed_emoji
    @processed = Twemoji.parse(@processed, image_size: "36x36")
  end

  def spoilers
    @processed.gsub!(/\[spoiler\](.*)\[\/spoiler\]/, '<span class="spoiler">\1</span>')
  end

  MAX_IMAGE_FILE_SIZE = 2.megabytes
  IMAGE_REGEX = /\.(png|jpg|jpeg|gif|bmp|tif|tiff)$/i

  def filesize(link)
    Timeout::timeout(5) { open(link).size }
  rescue
    Float::INFINITY
  end
end
