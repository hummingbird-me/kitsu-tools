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

# Convert path overrides in development to absolute paths
if Rails.env.development?
  Paperclip::Attachment.class_eval do
    alias_method :org_initialize, :initialize

    def initialize(name, instance, options = {})
      org_initialize(name, instance, options)
      unless @options[:path] == self.class.default_options[:path]
        @options[:url] = "/uploads#{@options[:path]}"
        @options[:path] = "#{Rails.root}/public/uploads#{@options[:path]}"
      end
    end
  end
end
