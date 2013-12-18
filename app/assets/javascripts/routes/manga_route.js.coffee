Hummingbird.MangaRoute = Ember.Route.extend
  model: (params) ->
    @store.find 'manga', params.id
