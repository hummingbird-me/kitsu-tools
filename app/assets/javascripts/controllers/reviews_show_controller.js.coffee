Hummingbird.ReviewsShowController = Ember.ObjectController.extend
  coverImageStyle: (->
    "background-image: url(" + @get('user.coverImageUrl') + ")"
  ).property('user.coverUrl')

  writtenBySelf: (->
    @get('currentUser.isSignedIn') and @get('currentUser.id') == @get('user.id')
  ).property('user.id')
