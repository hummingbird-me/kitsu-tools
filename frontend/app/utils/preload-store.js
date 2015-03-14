import Ember from "ember";

var preloadStore = {
  get: function(key, fetch) {
    if(!window.genericPreload) { window.genericPreload = {}; }
    if (typeof window.genericPreload[key] !== "undefined") {
      return window.genericPreload[key];
    } else if (typeof fetch !== "undefined") {
      return fetch();
    }
  },

  pop: function(key, fetch) {
    var value = preloadStore.get(key, fetch);
    delete window.genericPreload[key];
    return value;
  },

  popEmberData: function(key, path, object, store, edQuery) {
    var data = preloadStore.pop(key);
    if (typeof data === "undefined" || data === null) {
      if (typeof edQuery !== "undefined") {
        return edQuery();
      } else {
        return null;
      }
    }
    store.pushPayload(data);
    var ids = data[path].map(function(x) { return x.id; });
    return new Ember.RSVP.Promise(function(resolve) {
      return resolve(store.findByIds(object, ids));
    });
  }
};

export default preloadStore;
