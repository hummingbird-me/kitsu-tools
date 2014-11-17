class AppSerializer < ActiveModel::Serializer
  embed :ids

  attributes :id, :key, :secret, :name
  has_one :creator, embed_key: :name

  # Only show secret+key if the scope is the creator
  def include_secret?
    scope == object.creator if scope
  end
  alias_method :include_key?, :include_secret?
end
