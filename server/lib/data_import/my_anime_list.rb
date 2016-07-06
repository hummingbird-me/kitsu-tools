module DataImport
  class MyAnimeList
    ATARASHII_API_HOST = 'https://hbv3-mal-api.herokuapp.com/2.1/'.freeze

    include DataImport::Media
    include DataImport::HTTP

    attr_reader :opts

    def initialize(opts = {})
      @opts = opts.with_indifferent_access
      super()
    end

    def get_media(external_id) # anime/1234 or manga/1234
      media = Mapping.lookup('myanimelist', external_id)
      klass = external_id.split('/').first.classify.constantize # should return Anime or Manga
      media ||= klass.new # picks the class

      get(external_id) do |response|
        details = Extractor::Media.new(response)

        media.assign_attributes(details.to_h.compact)
        media.genres = details.genres.map do |genre|
          Genre.find_by(name: genre)
        end.compact

        yield media
      end
    end

    private

    def get(url, opts = {})
      super(build_url(url), opts)
    end

    def build_url(path)
      return path if path.include?('://')
      "#{ATARASHII_API_HOST}#{path}"
    end
  end
end
