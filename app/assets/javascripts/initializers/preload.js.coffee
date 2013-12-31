Ember.Application.initializer
  name: 'preload'

  initialize: (container) ->
    store = container.lookup('store:main')
    for item in window.preloadData
      store.pushPayload item
