module DataImport
  module Media
    extend ActiveSupport::Concern

    # Retrieve multiple media, by default just maps over get_media
    #
    # @param [Array<String>] list of external IDs to load
    # @return [Hash<String, Media>] a hash of external_id => media
    def get_multiple_media(external_ids)
      external_ids.each { |id| get_media(id) { |media| yield id, media } }
    end

    # Retrieve media information by external ID
    #
    # @param [String] external ID to load
    # @return [Media] a hash of standardized attributes
    def get_media(*)
      raise 'Override DataImport::Media#get_media with your own implementation'
    end
  end
end
