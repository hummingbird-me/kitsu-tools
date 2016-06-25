module DataImport
  class MyDramaList
    MDL_HOST = 'http://mydramalist.com/'

    include DataImport::Media
    include DataImport::HTTP

    # @attr_reader [ActiveSupport::HashWithIndifferentAccess] options
    # (specific to implementation) such as API token or host.
    attr_reader :opts

    def initialize(opts = {})
      @opts = opts.with_indifferent_access
      super
    end

    def get_media(external_id)
      media = Mappings.lookup('mydramalist', external_id)
      parallel_get([
        "/#{external_id}",
        "/#{external_id}/cast"
      ]) do |main_page, cast_page|
        details = Extractor::Details.new(main_page)
        cast = Extractor::Cast.new(cast_page)
        # TODO: build the object tree and yield it out
      end
    end

    private

    def get(url, opts = {})
      super(build_url(url), opts)
    end

    def build_url(path)
      return path if path.include?('://')
      "#{MDL_HOST}#{path}"
    end
  end
end
