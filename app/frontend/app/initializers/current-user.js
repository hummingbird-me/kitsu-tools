export function initialize(container) {
  var user, store = container.lookup('store:main'),
      controller = container.lookup('controller:current-user');
  if (window.currentUserName) {
    user = store.find('current-user', window.currentUserName);
    controller.set('model', user);
  }
  container.injection('route', 'currentUser', 'controller:current-user');
  container.injection('view', 'currentUser', 'controller:current-user');
}

export default {
  name: 'current-user',
  after: 'preload',
  initialize: initialize
};
