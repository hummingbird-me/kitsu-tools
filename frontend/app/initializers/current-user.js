export function initialize(container, app) {
  ['route', 'view', 'component', 'controller'].forEach((component) => {
    app.inject(component, 'currentUser', 'service:current-user');
  });

  if (window.currentUserName) {
    let store = container.lookup('store:main');
    let user = store.find('current-user', window.currentUserName);
    container.lookup('service:current-user').set('content', user);
  }
}

export default {
  name: 'current-user',
  after: 'preload',
  initialize: initialize
};
