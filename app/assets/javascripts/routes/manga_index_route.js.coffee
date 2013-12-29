Hummingbird.MangaIndexRoute = Ember.Route.extend
  model: ->
    @modelFor 'manga'

  afterModel: (resolvedModel) ->
    Hummingbird.TitleManager.setTitle resolvedModel.get('romajiTitle')

