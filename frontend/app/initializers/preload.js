export function initialize(container) {
  if (window.preloadData) {
    var store = container.lookup('store:main');
    window.preloadData.forEach(function(item) {
      store.pushPayload(item);
    });
  }
}

export default {
  name: 'preload',
  after: 'store',
  initialize: initialize
};
