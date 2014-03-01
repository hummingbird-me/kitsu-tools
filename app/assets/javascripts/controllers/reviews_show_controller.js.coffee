Hummingbird.ReviewsShowController = Ember.ObjectController.extend
  coverImageStyle: (->
    "background-image: url(" + @get('user.coverImageUrl') + ")"
  ).property('user.coverUrl')

  writtenBySelf: (->
    @get('currentUser.isSignedIn') and @get('currentUser.id') == @get('user.id')
  ).property('user.id')

  ratingFirstDigit: (->
    Math.floor @get('model.rating')
  ).property('model.rating')

  ratingDecimalPart: (->
    "." + (Math.floor ((@get('model.rating') - @get('ratingFirstDigit')) * 10))
  ).property('model.rating')

  breakdown: (->
    self = this
    breakdown = []
    ['model.ratingStory', 'model.ratingAnimation', 'model.ratingSound', 'model.ratingCharacters', 'model.ratingEnjoyment'].forEach (property) ->
      breakdown.push Ember.Object.create(
        title: property.substr(12)
        positive: self.get(property) > 2.4
        rating: self.get(property).toFixed(1)
      )
    breakdown
  ).property('model.ratingStory', 'model.ratingAnimation', 'model.ratingSound', 'model.ratingCharacters', 'model.ratingEnjoyment')

  editPath: (->
    "/anime/" + @get('model.anime.id') + "/reviews/" + @get('model.id') + "/edit"
  ).property('model.id', 'model.anime.id')

  upvoted: (-> @get('model.liked') == "true" ).property('model.liked')
  downvoted: (-> @get('model.liked') == "false" ).property('model.liked')
