Hummingbird.UserMangaLibraryRoute = Ember.Route.extend
  model: (params) ->
    user_id = @modelFor('user').get('id')
    @store.find 'mangaLibraryEntry', user_id: user_id, status: "Currently Reading"

  setupController: (controller, model) ->
    controller.set 'model', model
    # Load remaining library entries.
    controller.set 'loadingRemaining', true
    user_id = @modelFor('user').get('id')
    @store.find('mangaLibraryEntry', user_id: user_id).then (entries) ->
      controller.get('content').addObjects entries.filter((l) -> l.get('status') != "Currently Reading")
      controller.set 'loadingRemaining', false

  deactivate: ->
    @controllerFor('user.library').set 'model', []

  afterModel: ->
    Hummingbird.TitleManager.setTitle @modelFor('user').get('id') + "'s Library"
