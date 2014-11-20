# By default, Paperclips `UriAdapter` uses the `Content-Type` response header
# to determine the file type. It turns out that not all image hosts set that
# header.

Paperclip::UriAdapter.class_eval do
  alias_method :org_cache_current_values, :cache_current_values

  # `UriAdapter` defines `@tempfile` after `cache_current_values`
  def initialize(target)
    @target = target
    @content = download_content
    @tempfile = copy_to_tempfile(@content)
    cache_current_values
  end

  def cache_current_values
    org_cache_current_values
    # `open` will return a StringIO object if the content is small in size.
    file = if @content.is_a?(Tempfile)
      @content
    else
      @tempfile
    end
    @content_type = Paperclip::ContentTypeDetector.new(file.path).detect
  end
end
