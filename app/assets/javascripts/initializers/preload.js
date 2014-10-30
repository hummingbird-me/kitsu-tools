Ember.Application.initializer({
  name: 'preload',

  initialize: function(container) {
    if (window.preloadData) {
      var store = container.lookup('store:main');
      window.preloadData.forEach(function(item) {
        store.pushPayload(item);
      });
    }
  }
});
