require 'timeout'

class MessageFormatter
  def initialize(message)
    @message = message
    @processed = message

    # Apply filters.
    autolink
    link_usernames
    process_newlines
    embed_image_or_youtube
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
      if user = User.find_by(name: x[1..-1])
        "<span class='name'>@<a href='//hummingbird.me/users/#{user.name}' target='_blank' data-user-name='#{user.name}'>#{user.name}</a></span>"
      else
        x
      end
    end
  end

  def process_newlines
    @processed.gsub!(/\n{3,}/, "\n\n")
    @processed.gsub!(/\n/, "<br>")
  end

  def embed_image_or_youtube
    noko = Nokogiri::HTML.fragment(@processed)
    links = noko.css('a').map {|link| link['href'] }

    # Only do autoembedding if there is exactly one link.
    return if links.length != 1
    link = links.first

    if embeddable_image?(link)
      delete_links
      if @processed.strip.length > 0 && !(@processed =~ /(<br\s?\/?>\s*){2,}$/)
        @processed += "<br>"
      end
      @processed += "<a href='#{link}'><img class='autoembed' src='#{link}' style='max-height: 500px; width: auto;' /></a>"
    elsif code = embeddable_video_code(link)
      delete_links
      @processed += "<div class='video-embed'><div class='video-wrapper'><iframe width='350' height='240' frameborder='0' class='autoembed' allowfullscreen src='http://youtube.com/embed/#{code}'> </iframe></div></div>"
    end
  end

  def embeddable_image?(link)
    link =~ /\.(gif|jpe?g|png)$/i && filesize(link) <= 1024 * 1024 * 2
  end

  def filesize(link)
    Timeout::timeout(5) { return open(link).size }
  rescue
    return 1.0 / 0
  end

  def embeddable_video_code(link)
    return unless link =~ /(?:http:\/\/)?(?:www\.)?(?:youtube\.com|youtu\.be)\/(?:watch\?v=)?(.+)/
    link.scan(/v=([A-Za-z0-9\-_]+)/)[0][0]
  rescue
    nil
  end

  def delete_links
    @processed = Nokogiri::HTML.fragment(@processed).tap {|x| x.css('a').remove }.to_s
  end
end
