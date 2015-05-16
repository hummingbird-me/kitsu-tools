import Ember from 'ember';

let XContentReady = new CustomEvent('XContentReady');

export function initialize(instance) {
  let router = instance.container.lookup('router:main');
  document.addEventListener('XPushState', (e) => {
    Ember.run(() => {
      router.replaceWith(e.url).then((route) => {
        if (route.handlerInfos) {
          // The route was already loaded
          document.dispatchEvent(XContentReady);
        }
      });
    });
  });
}

export default {
  name: 'x-push-state',
  initialize: initialize
};
