module MicrodataHelper
  def schema_prop(prop, val = nil)
    tag_options({
      itemprop: prop.to_s,
      content: val
    }.compact).html_safe
  end
  def schema_scope(schema, prop = nil)
    tag_options({
      itemtype: "http://schema.org/#{schema.to_s}".to_s,
      itemprop: prop.to_s,
      itemscope: true
    }.compact).html_safe
  end
  def schema_image(prop, url, opts = {})
    schema_tag(:img, prop, url, {
      src: url
    }.merge(opts)).html_safe
  end
  def schema_tag(tag, prop, val = nil, opts = {})
    tag(tag, {
      itemprop: prop.to_s,
      content: val
    }.merge(opts)).html_safe
  end
end
