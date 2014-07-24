Hummingbird.PreloadStore = {
  get: function(key) {
    return window.genericPreload[key];
  },

  pop: function(key) {
    var value = Hummingbird.PreloadStore.get(key);
    delete window.genericPreload[key];
    return value;
  }
};
