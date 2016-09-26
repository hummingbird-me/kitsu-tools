module DataImport
  class MyAnimeList
    ATARASHII_API_HOST = 'https://hbv3-mal-api.herokuapp.com/2.1/'.freeze
    MY_ANIME_LIST_HOST = 'https://myanimelist.net/'.freeze

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
      external_id = "character/#{external_id}"
      character = Mapping.lookup('myanimelist', external_id)
      character ||= Character.new

      get(MY_ANIME_LIST_HOST, external_id) do |response|
        details = Extractor::Character.new(response)

        character.assign_attributes(details.to_h.compact)

        yield character
      end
    end

    private

    def get(host, url, opts = {})
      super(build_url(host, url), opts)
    end

    def build_url(host, path)
      "#{host}#{path}"
    end
  end
end
