# By default, Paperclips `UriAdapter` uses the `Content-Type` response header
# to determine the file type. It turns out that not all image hosts set that
# header.

Paperclip::UriAdapter.class_eval do
  alias_method :org_cache_current_values, :cache_current_values

  def cache_current_values
    org_cache_current_values
    @content_type = Paperclip::ContentTypeDetector.new(@content.path).detect
  end
end
