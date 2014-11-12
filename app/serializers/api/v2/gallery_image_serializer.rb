module Api::V2
  class GalleryImageSerializer < Serializer
    field(:thumb) {|i| i.image.url(:thumb) }
    field(:original) {|i| i.image.url(:original) }
  end
end
