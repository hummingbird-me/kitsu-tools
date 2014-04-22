require 'timeout'

class MessageFormatter
  def self.format_message(message)
    formatted = Rinku.auto_link(ERB::Util.html_escape(message), :all, 'target="_blank"')

    # Replace newlines with <br>.
    formatted = formatted.strip.gsub(/\n{3,}/, "\n\n")
    formatted = formatted.gsub(/\n/, "<br>")

    # Link @usernames.
    formatted = formatted.gsub(/@[-_A-Za-z0-9]+/) do |x|
      u = User.find_by_name(x[1..-1])
      if u
        "<span class='name'>@<a href='#{Rails.application.routes.url_helpers.user_path(u)}' target='_blank' data-user-name='#{u.name}'>#{u.name}</a></span>"
      else
        x
      end
    end

    noko = Nokogiri::HTML.parse formatted
    links = noko.css('a').map {|link| link['href'] }
    if links.length > 0
      link = links[-1]

      # Embed images.
      if link =~ /\.(gif|jpe?g|png)$/i
        begin
          Timeout::timeout(5) do
            if open(link).size <= 1024*1024*2
              formatted += "<br><a href='#{link}'><img class='autoembed' src='#{link}' style='max-height: 500px; width: auto;' /></a>"
            end
          end
        rescue
        end
      end

      # Embed YouTube videos.
      if link =~ /(?:http:\/\/)?(?:www\.)?(?:youtube\.com|youtu\.be)\/(?:watch\?v=)?(.+)/
        begin
          code = link.scan(/v=([A-Za-z0-9\-_]+)/)[0][0]
          formatted += "<div class='video-embed'><div class='video-wrapper'><iframe width='350' height='240' frameborder='0' class='autoembed' allowfullscreen src='http://youtube.com/embed/#{code}' > </iframe></div></div>"
        rescue
        end
      end
    end

    formatted
  end
end
