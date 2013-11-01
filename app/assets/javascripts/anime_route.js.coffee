Hummingbird.AnimeRoute = Ember.Route.extend
  model: (params) ->
    @store.find 'anime', params.id
