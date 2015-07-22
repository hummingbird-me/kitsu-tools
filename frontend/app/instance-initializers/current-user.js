export function initialize(instance) {
  if (window.currentUserName) {
    let store = instance.container.lookup('store:main');
    let user = store.find('current-user', window.currentUserName);
    instance.container.lookup('service:current-user').set('content', user);
  }
}

export default {
  name: 'current-user',
  after: 'preload',
  initialize: initialize
};
