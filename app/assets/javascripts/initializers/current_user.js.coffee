Ember.Application.initializer
  name: 'current-user'
  after: 'preload'

  initialize: (container) ->
    store = container.lookup('store:main')
    controller = container.lookup('controller:currentUser')
    if window.currentUserName
      user = store.find 'user', window.currentUserName
      controller.set 'content', user

    container.injection 'controller', 'currentUser', 'controller:currentUser'
    container.injection 'route', 'currentUser', 'controller:currentUser'
