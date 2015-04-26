import currentUserProxy from '../services/current-user.js';

export function initialize(container, app) {
  var user, store = container.lookup('store:main');

  app.register('service:current-user', currentUserProxy);

  if (window.currentUserName) {
    user = store.find('current-user', window.currentUserName);
    currentUserProxy.set('content', user);
  }

  app.inject('route', 'currentUser', 'service:current-user');
  app.inject('view', 'currentUser', 'service:current-user');
  app.inject('component', 'currentUser', 'service:current-user');
  app.inject('controller', 'currentUser', 'service:current-user');
}

export default {
  name: 'current-user',
  after: 'preload',
  initialize: initialize
};
