module DataImport
  class MyAnimeList
    ATARASHII_API_HOST = 'https://hbv3-mal-api.herokuapp.com/2.1/'.freeze
    MY_ANIME_LIST_HOST = 'http://myanimelist.net/'.freeze

    include DataImport::Media
    include DataImport::HTTP

    attr_reader :opts

    def initialize(opts = {})
      @opts = opts.with_indifferent_access
      super()
    end

    def get_media(external_id) # anime/1234 or manga/1234
      media = Mapping.lookup('myanimelist', external_id)
      # should return Anime or Manga
      klass = external_id.split('/').first.classify.constantize
      # initialize the class
      media ||= klass.new

      get(ATARASHII_API_HOST, external_id) do |response|
        details = Extractor::Media.new(response)

        media.assign_attributes(details.to_h.compact)
        media.genres = details.genres.map { |genre|
          Genre.find_by(name: genre)
        }.compact

        yield media
      end
    end

    def get_character(external_id)
      media = Mapping.lookup('myanimelist', external_id)
      media ||= Character.new

      get(MY_ANIME_LIST_HOST, external_id) do |response|
        character = Extractor::Character.new(response, external_id)

        media.assign_attributes(character.to_h.compact)

        yield media
      end
    end

    private

    def get(host, url, opts = {})
      super(build_url(host, url), opts)
    end

    def build_url(host, path)
      return path if path.include?('://')
      "#{host}#{path}"
    end
  end
end
