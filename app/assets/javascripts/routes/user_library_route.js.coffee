Hummingbird.UserLibraryRoute = Ember.Route.extend
  model: (params) ->
    user_id = @modelFor('user').get('id')
    @store.find 'libraryEntry', user_id: user_id

  deactivate: ->
    @controllerFor('user.library').set 'model', []

  afterModel: ->
    Hummingbird.TitleManager.setTitle @modelFor('user').get('id') + "'s Library"
