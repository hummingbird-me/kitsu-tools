Hummingbird.UserController = Ember.ObjectController.extend
  coverImageStyle: (->
    "background-image: url(" + @get('model.coverImageUrl') + ")"
  ).property('model.coverImageUrl')

  # Legacy URLs
  feedURL: (->
    "/users/" + @get('model.username') + "/feed"
  ).property('model.username')
  libraryURL: (->
    "/users/" + @get('model.username') + "/watchlist"
  ).property('model.username')
