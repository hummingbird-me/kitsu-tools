Hummingbird.NotificationsRoute = Ember.Route.extend
  model: ->
    @store.find 'notification'
