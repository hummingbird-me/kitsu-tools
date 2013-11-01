Ember.Application.initializer
  name: 'preload'

  initialize: (container) ->
    store = container.lookup('store:main')
    for key, value of window.preloadData
      store.pushPayload key, value
