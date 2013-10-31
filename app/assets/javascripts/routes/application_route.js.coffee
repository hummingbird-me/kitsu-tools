Hummingbird.ApplicationRoute = Ember.Route.extend
  setupController: ->
    console.log "PUSHPAYLOAD"
    for value in window.preloadData
      @get('store').pushPayload value

