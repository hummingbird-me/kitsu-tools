class AppSerializer < ActiveModel::Serializer
  embed :ids

  attributes :id, :key, :secret, :name, :homepage, :description, :redirect_uri,
             :logo
  has_one :creator, embed_key: :name

  # Only show secret+key if the scope is the creator
  def include_secret?
    scope == object.creator if scope
  end
  alias_method :include_key?, :include_secret?
  alias_method :include_redirect_uri?, :include_secret?
end
