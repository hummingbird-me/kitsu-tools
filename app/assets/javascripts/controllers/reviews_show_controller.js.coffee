Hummingbird.ReviewsShowController = Ember.ObjectController.extend
  coverImageStyle: (->
    console.log
    "background-image: url(" + @get('user.coverImageUrl') + ")"
  ).property('user.coverUrl')
