Ember.Application.initializer({
  name: 'preload',


  initialize: function(container) {
    var item, store, i, length, ref, results;
    store = container.lookup('store:main');
    if (window.preloadData) {
      ref = window.preloadData;
      results = [];
      for (i = 0, length = ref.length; i < length; i++) {
        item = ref[i];
        results.push(store.pushPayload(item));
      }
      return results;
    }
  }
});
