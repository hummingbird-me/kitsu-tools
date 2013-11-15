class CharacterSerializer < ActiveModel::Serializer
  attributes :id, :name, :image

  def image
    object.image.url(:thumb)
  end
end
