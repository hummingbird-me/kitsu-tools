module DataImport
  class MyAnimeList
    ATARASHII_API_HOST = "https://hbv3-mal-api.herokuapp.com/2.1/"

    include DataImport::Media
    include DataImport::HTTP

    attr_reader :opts

    def initialize(opts = {})
      @opts = opts.with_indifferent_access
      super()
    end

    def get_media(external_id) # anime/1234 or manga/1234
      type = external_id.split('/') # going to be used when adding manga
      media = Mapping.lookup('myanimelist', external_id) || type.first.classify.constantize.new # should return Anime.new or Manga.new

      get(external_id) do |response|
        details = Extractor::Media.new(response)

        media.assign_attributes(details.to_h)
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

  end # end of class
end # end of module
