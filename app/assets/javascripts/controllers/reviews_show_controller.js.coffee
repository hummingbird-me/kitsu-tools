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

  ratingStory: (-> @get('model.ratingStory').toFixed(1) ).property('model.ratingStory')
  ratingAnimation: (-> @get('model.ratingAnimation').toFixed(1) ).property('model.ratingAnimation')
  ratingSound: (-> @get('model.ratingSound').toFixed(1) ).property('model.ratingSound')
  ratingCharacters: (-> @get('model.ratingCharacters').toFixed(1) ).property('model.ratingCharacters')
  ratingEnjoyment: (-> @get('model.ratingEnjoyment').toFixed(1) ).property('model.ratingEnjoyment')
