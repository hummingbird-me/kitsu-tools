export function initialize(instance) {
  if (window.preloadData) {
    let store = instance.container.lookup('store:main');
    window.preloadData.forEach((item) => {
      store.pushPayload(item);
    });
  }
}

export default {
  name: 'preload',
  initialize: initialize
};
