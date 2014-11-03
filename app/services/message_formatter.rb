require 'timeout'

class MessageFormatter
  def initialize(message)
    @message = message
    @processed = message

    # Apply filters.
    autolink
    link_usernames
    process_newlines
    embed_media
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
    noko = Nokogiri::HTML.fragment(@processed)
    links = noko.css('a').map {|link| link['href'] }

    embeddable_links = links.select {|link| embeddable_link?(link) }
    return if embeddable_links.length != 1
    link = embeddable_links.first

    if embeddable_image?(link)
      delete_link(link)
      if @processed.strip.length > 0 && !(@processed =~ /(<br\s?\/?>\s*){2,}$/)
        @processed += "<br>"
      end
      @processed += "<a href='#{link}' target='_blank'><img class='autoembed' src='#{link}' style='max-height: 500px; width: auto; max-width: 100%;' /></a>"
    elsif gfy = embeddable_gfy(link)
      delete_link(link)
      @processed += "<div class='video-embed clearfix'><div class='gfy-wrapper'><iframe width='#{gfy[:width]}' height='#{gfy[:height]}' frameborder='0' class='autoembed' src='//gfycat.com/ifr/#{gfy[:code]}'></iframe></div></div>"
    elsif data = embeddable_video_code(link)
      delete_link(link)
      code, time = data
      # time needs to be converted to seconds
      match_data = /(?:(?:(\d+)h)?(?:(\d+)m)?(?:(\d+)s))/.match(time)
      time = if match_data
        (match_data[1].to_i * (60 * 60)) + (match_data[2].to_i * 60) + match_data[3].to_i
      else
        0
      end
      @processed += "<div class='video-embed clearfix'><div class='video-wrapper'><iframe width='350' height='240' frameborder='0' class='autoembed' allowfullscreen src='https://youtube.com/embed/#{code}?start=#{time}'></iframe></div></div>"
    end
  end

  def spoilers
    @processed.gsub!(/\[spoiler\](.*)\[\/spoiler\]/, '<span class="spoiler">\1</span>')
  end

  def embeddable_link?(link)
    embeddable_image?(link) || (embeddable_video_code(link) != nil) || (embeddable_gfy(link) != nil)
  end

  def embeddable_image?(link)
    link =~ /\.(gif|jpe?g|png)$/i && filesize(link) <= 1024 * 1024 * 2
  end

  def embeddable_video_code(link)
    return unless match_data = /(?:youtube\.com\/(?:v\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})(?:\S*[?&]t=(\w*))?/.match(link)
    [match_data[1], match_data[2]]
  rescue
    nil
  end

  def embeddable_gfy(link)
    return unless match_data = /^https?:\/\/gfycat\.com\/(\w+)/.match(link)
    code = match_data[1]
    json = Timeout::timeout(5) do
      JSON.parse(open("http://gfycat.com/cajax/get/#{code}").read)
    end
    {
      code: code,
      width: json["gfyItem"]["width"],
      height: json["gfyItem"]["height"]
    }
  rescue
    nil
  end

  def filesize(link)
    Timeout::timeout(5) { return open(link).size }
  rescue
    return 1.0 / 0
  end

  def delete_link(link)
    @processed = Nokogiri::HTML.fragment(@processed).tap do |fragment|
      fragment.css('a').select do |anchor|
        anchor['href'] == link
      end.each(&:remove)
    end.to_s
  end
end
