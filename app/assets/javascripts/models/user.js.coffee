Hummingbird.User = DS.Model.extend
  username: Ember.computed.alias('id')
  coverImageUrl: DS.attr('string')
  avatarTemplate: DS.attr('string')
  online: DS.attr('boolean')
  miniBio: DS.attr('string')
  bio: DS.attr('string')
  location: DS.attr('string')
  website: DS.attr('string')
  waifu: DS.attr('string')
  waifuOrHusbando: DS.attr('string')
  ratingType: DS.attr('string')

  isFollowed: DS.attr('boolean')

  titleLanguagePreference: DS.attr('string')

  avatarUrl: (->
    @get("avatarTemplate").replace('{size}', 'thumb')
  ).property('avatarTemplate')

  coverImageStyle: (->
   "background-image: url(" +  @get('coverImageUrl') + ")"
  ).property('coverImageUrl')

  userLink: (->
    "/users/" + @get('id')
  ).property('id')
