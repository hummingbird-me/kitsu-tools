Hummingbird.AnimeRoute = Ember.Route.extend
  model: (params) ->
    @store.find 'anime', params.id

  title: (->
    @modelFor("anime").get("canonicalTitle")
  ).property('model.canonicalTitle')
