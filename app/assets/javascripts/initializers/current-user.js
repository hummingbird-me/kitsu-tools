Ember.Application.initializer({
  name: 'current-user',
  after: 'preload',

  initialize: function(container) {
    var user, store = container.lookup('store:main'),
        controller = container.lookup('controller:currentUser');
    if (window.currentUserName) {
      user = store.find('currentUser', window.currentUserName);
      controller.set('model', user);
    }
    container.injection('route', 'currentUser', 'controller:currentUser');
    container.injection('view', 'currentUser', 'controller:currentUser');
  }
});
