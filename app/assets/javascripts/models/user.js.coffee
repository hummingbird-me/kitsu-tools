Hummingbird.User = DS.Model.extend
  username: DS.attr('string')
  coverImageUrl: DS.attr('string')
  avatarTemplate: DS.attr('string')
  online: DS.attr('boolean')
  about: DS.attr('string')
  ratingType: DS.attr('string')

  isFollowed: DS.attr('boolean')

  avatarUrl: (->
    @get("avatarTemplate").replace('{size}', 'thumb')
  ).property('avatarTemplate')

