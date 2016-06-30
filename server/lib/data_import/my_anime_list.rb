module DataImport
  class MyAnimeList
    MDL_HOST = "https://hbv3-mal-api.herokuapp.com/2.1" # 2.1 is the api version, MAYBE add graceful decay to check from v1 if it can't find?

    include DataImport::Media
    include DataImport::HTTP

    attr_reader :opts

    def initialize(opts = {})
      @opts = opts.with_indifferent_access
      super()
    end

    def get_media(external_id) # anime/1234 or manga/1234
      media = Mapping.lookup('myanimelist', external_id) || Anime.new

      get(external_id) do |response|
        # details = Extractor::Details.new(response)

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

  end # end of class
end # end of module
