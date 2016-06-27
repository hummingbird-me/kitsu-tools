module DataImport
  class MyDramaList
    MDL_HOST = 'http://mydramalist.com/'
    GENRE_MAPPINGS = {
      'Manga' => nil, # Manga-inspired, use Franchise instead
      'Detective' => 'Investigation', # These genres are mostly the same
      'Wuxia' => 'Martial Arts', # Wuxia is a specific subset
      'Animals' => nil # wtf this is absurdly specific
    }

    include DataImport::Media
    include DataImport::HTTP

    # @attr_reader [ActiveSupport::HashWithIndifferentAccess] options
    # (specific to implementation) such as API token or host.
    attr_reader :opts

    def initialize(opts = {})
      @opts = opts.with_indifferent_access
      super()
    end

    def get_media(external_id)
      media = Mapping.lookup('mydramalist', external_id) || Drama.new
      parallel_get([
        "/#{external_id}",
        "/#{external_id}/cast"
      ]) do |main_page, cast_page|
        details = Extractor::Details.new(main_page)
        cast = Extractor::CastList.new(cast_page)

        media.assign_attributes(details.to_h)
        media.genres = details.genres.map do |genre|
          genre = GENRE_MAPPINGS[genre] if GENRE_MAPPINGS.include? genre
          Genre.find_by(name: genre)
        end.compact
        p media.genres
        yield media
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
