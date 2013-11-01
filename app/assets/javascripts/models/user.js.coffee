Hummingbird.User = DS.Model.extend
  username: DS.attr('string')
  coverImageUrl: DS.attr('string')
  avatarTemplate: DS.attr('string')
  online: DS.attr('boolean')
  about: DS.attr('string')

  isFollowed: DS.attr('boolean')

  avatarUrl: (->
    @get("avatarTemplate").replace('{size}', 'thumb')
  ).property('avatarTemplate')

Hummingbird.UserSerializer = Hummingbird.ApplicationSerializer.extend
  normalize: (type, hash, property) ->
    hash['id'] = hash['username']
    @_super(type, hash, property)

