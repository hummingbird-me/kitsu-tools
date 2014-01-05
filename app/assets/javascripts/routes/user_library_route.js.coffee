Hummingbird.UserLibraryRoute = Ember.Route.extend
  afterModel: ->
    Hummingbird.TitleManager.setTitle @modelFor('user').get('id') + "'s Library"
