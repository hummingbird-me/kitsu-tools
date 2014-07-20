class EpisodeSerializer < ActiveModel::Serializer
  embed :ids

  attributes :id,
             :number,
             :title,
             :thumbnail,
             :synopsis

  has_one :anime, embed_key: :slug
end
