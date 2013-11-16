class PersonSerializer < ActiveModel::Serializer
  attributes :id, :name, :image

  def image
    object.image.url(:thumb_small)
  end
end
