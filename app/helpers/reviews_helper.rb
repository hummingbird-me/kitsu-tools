module ReviewsHelper
  def simple_format_review(text, html_options={}, options={})
    text = '' if text.nil?
    text = text.dup
    text = sanitize_review(text) unless options[:sanitize] == false
    text = text.to_str
    text.gsub!(/\r\n?/, "\n")                    # \r\n and \r -> \n
    text.gsub!(/(\n)?\n+/, "</p>\n\n<p>")  # 2+ newline  -> paragraph
    text.insert 0, "<p>"
    text.html_safe.safe_concat("</p>")
  end

  def sanitize_review(html)
    allow_youtube_transformer = lambda do |env|
      node      = env[:node]
      node_name = env[:node_name]

      # Don't continue if this node is already whitelisted or is not an 
      # element.
      return if env[:is_whitelisted] || !node.element?

      # Don't continue unless the node is an iframe.
      return unless node_name == 'iframe'

      # Verify that the video URL is actually a valid video URL.
      video_url_regexes = [
        /\Ahttps?:\/\/(?:www\.)?youtube(?:-nocookie)?\.com\//,
        /\A\/\/(?:www\.)?youtube(?:-nocookie)?\.com\//,
        /\Ahttps?:\/\/player\.vimeo\.com\/video/,
        /\Ahttps?:\/\/ext\.nicovideo\.jp\/thumb/,
        /\Ahttps?:\/\/www\.dailymotion\.com\/embed\/video/,
        /\Ahttps?:\/\/www\.wat\.tv\/embedframe/
      ]
      return unless video_url_regexes.any? {|x| node['src'] =~ x }

      # We're now certain that this is a YouTube embed, but we still need to 
      # run it through a special Sanitize step to ensure that no unwanted 
      # elements or attributes that don't belong in a YouTube embed can sneak
      # in.
      Sanitize.clean_node!(node, {
        :elements => %w[iframe],
        :attributes => {
          'iframe'  => %w[allowfullscreen frameborder height src width]
        }
      })

      # Now that we're sure that this is a valid YouTube embed and that there 
      # are no unwanted elements or attributes hidden inside it, we can tell 
      # Sanitize to whitelist the current node.
      {:node_whitelist => [node]}
    end

    configuration = {
      :elements => %w[
        a abbr b bdo blockquote br caption cite code col colgroup dd del dfn
        dl dt em figcaption figure h1 h2 h3 h4 h5 h6 hgroup i img ins kbd li 
        mark ol p pre q rp rt ruby s samp small strike strong sub sup table 
        tbody td tfoot th thead time tr u ul var wbr
      ],
      :attributes => {
        :all => ['dir', 'lang', 'title'],
        'a' => ['href', 'target'],
        'blockquote' => ['cite'],
        'col' => ['span', 'width'],
        'colgroup' => ['span', 'width'],
        'del' => ['cite', 'datetime'],
        'img' => ['align', 'alt', 'height', 'src', 'width'],
        'ins' => ['cite', 'datetime'],
        'ol' => ['start', 'reversed', 'type'],
        'q' => ['cite'],
        'table' => ['summary', 'width'],
        'td' => ['abbr', 'axis', 'colspan', 'rowspan', 'width'],
        'th' => ['abbr', 'axis', 'colspan', 'rowspan', 'scope', 'width'],
        'time' => ['datetime', 'pubdate'],
        'ul' => ['type']
      },
      :protocols => {
        'a' => {'href' => ['ftp', 'http', 'https', 'mailto', :relative]},
        'blockquote' => {'cite' => ['http', 'https', :relative]},
        'del' => {'cite' => ['http', 'https', :relative]},
        'img' => {'src' => ['http', 'https', :relative]},
        'ins' => {'cite' => ['http', 'https', :relative]},
        'q' => {'cite' => ['http', 'https', :relative]}
      },
      :transformers => [allow_youtube_transformer]
    }

    html = Sanitize.clean(html, configuration).html_safe
    noko = Nokogiri::HTML.fragment(html)

    # Wrap youtube videos.
    noko.css('iframe').wrap('<div class="youtube-frame"></div>')
    noko.css('.youtube-frame').each {|node| node.add_child('<div class="youtube-background"></div>') }

    noko.to_html
  end

  def rating_description(r)
    return "Pathetic" if r == 1
    return "Dreadful" if r == 2
    return "Poor"     if r == 3
    return "Mediocre" if r == 4
    return "Fair"     if r == 5
    return "Decent"   if r == 6
    return "Good"     if r == 7
    return "Great"    if r == 8
    return "Amazing"  if r == 9
    return "Flawless" if r == 10
  end
end
