module DataImport
  class MyDramaList
    MDL_HOST = 'http://mydramalist.com/'

    include DataImport::Media
    include DataImport::HTTP

    def get_media(external_id)
      media = Mappings.lookup('mydramalist', external_id)
      get(["/#{external_id}", "/#{external_id}/cast"]) do |main_page, cast_page|
        details = Extractor::.new(main_page)
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
