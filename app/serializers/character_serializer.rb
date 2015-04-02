class CharacterSerializer < ActiveModel::Serializer
  attributes :id, :name, :image, :primary_media

  def image
    object.image.url(:thumb_small)
  end
end
