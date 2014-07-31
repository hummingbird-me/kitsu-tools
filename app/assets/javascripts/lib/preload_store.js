Hummingbird.PreloadStore = {
  get: function(key, fetch) {
    if (typeof window.genericPreload[key] !== "undefined") {
      return window.genericPreload[key];
    } else if (typeof fetch !== "undefined") {
      return fetch();
    }
  },

  pop: function(key, fetch) {
    var value = Hummingbird.PreloadStore.get(key, fetch);
    delete window.genericPreload[key];
    return value;
  },

  popAsync: function(key, fetchPromise) {
    var value = Hummingbird.PreloadStore.pop(key);
    if (typeof value !== "undefined") {
      return new Ember.RSVP.Promise(function(resolve, reject) {
        return resolve(value);
      });
    } else {
      return fetchPromise();
    }
  }
};
