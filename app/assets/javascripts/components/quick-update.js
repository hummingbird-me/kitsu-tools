Hummingbird.QuickUpdateComponent = Ember.Component.extend({
  loading: true,
  page: 1,
  libraryEntries: [],
  canGoBack: Em.computed.gt('page', 1),
  canGoForward: function() {
    return !this.get('loading') && this.get('libraryEntries.length') === 6;
  }.property('loading', 'libraryEntries.length'),

  fetchPage: function(page) {
    var store = this.get('targetObject.store')
        self = this;

    this.set('page', page);
    this.set('loading', true);

    var finder = function() {
      return store.find('libraryEntry', {recent: true, page: page});
    };

    // This is complicated, but we need it to preload the quick update on the
    // homepage.
    if (page === 1) {
      var finderED = finder;
      finder = function() {
        return Hummingbird.PreloadStore.popAsync('recent_library_entries', finderED).then(function(libraryEntries) {
          if (typeof libraryEntries["library_entries"] === "undefined") {
            // Loaded from Ember Data.
            return libraryEntries;
          } else {
            store.pushPayload(libraryEntries);
            var ids = libraryEntries["library_entries"].map(function (x) {
              return x.id;
            });
            return store.findByIds('libraryEntry', ids);
          }
        });
      };
    }

    finder().then(function(entries) {
      self.set('libraryEntries', entries);
      self.set('loading', false);
    });
  },

  fetchFirstPage: function() {
    this.fetchPage(1);
  }.on('didInsertElement'),

  setLoaderHeight: function() {
    var loadingElement = this.$(".update-loading"),
        height = loadingElement.width() * 290 / 200,
        heightProp = height + "px";

    loadingElement.css('height', heightProp)
                  .css('line-height', heightProp);
  }.on('didInsertElement'),

  actions: {
    goBack: function() {
      if (!this.get('canGoBack')) { return; }
      this.fetchPage(this.get('page') - 1);
    },

    goForward: function() {
      if (!this.get('canGoForward')) { return; }
      this.fetchPage(this.get('page') + 1);
    }
  }
});
