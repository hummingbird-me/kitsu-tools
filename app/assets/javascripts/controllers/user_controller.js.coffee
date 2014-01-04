Hummingbird.UserController = Ember.ObjectController.extend

  # Legacy URLs
  feedURL: (->
    "/users/" + @get('model.username') + "/feed"
  ).property('model.username')
  libraryURL: (->
    "/users/" + @get('model.username') + "/watchlist"
  ).property('model.username')
