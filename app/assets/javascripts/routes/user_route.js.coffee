Hummingbird.UserRoute = Ember.Route.extend
  model: (params) ->
    @store.find 'user', params.id
