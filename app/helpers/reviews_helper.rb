module ReviewsHelper
  def simple_format_review(text, html_options={}, options={})
    text = '' if text.nil?
    text = text.dup
    start_tag = tag('p', html_options, true)
    text = sanitize(text) unless options[:sanitize] == false
    text = text.to_str
    text.gsub!(/\r\n?/, "\n")                    # \r\n and \r -> \n
    text.gsub!(/\n\n+/, "</p>\n\n#{start_tag}")  # 2+ newline  -> paragraph
    text.gsub!(/([^\n]\n)(?=[^\n])/, "</p>\n\n#{start_tag}") # 1 newline   -> br
    text.insert 0, start_tag
    text.html_safe.safe_concat("</p>")
  end

  def sanitize_review(html)
    sanitize html
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
