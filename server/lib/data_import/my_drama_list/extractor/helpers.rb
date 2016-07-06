module DataImport
  class MyDramaList
    module Extractor
      module Helpers
        extend ActiveSupport::Concern

        private

        def original_for(src)
          src.sub(/_[a-z0-9]+\./, '_f.')
        end
      end
    end
  end
end
