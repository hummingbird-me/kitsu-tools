Ember.Application.initializer
  name: 'preload'

  initialize: (container) ->
    store = container.lookup('store:main')
    if window.preloadData
      for item in window.preloadData
        store.pushPayload item
