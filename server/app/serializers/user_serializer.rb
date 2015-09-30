class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :avatar, :cover_image, :bio, :about
end
