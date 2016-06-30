class DataImport::MyAnimeList
  module Extractor
    class Details
      attr_reader :dom

      def initialize(json)
        @dom = JSON.parse(json)
      end

    end
  end
end
