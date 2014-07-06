Hummingbird.QuickUpdateComponent = Ember.Component.extend({
  loading: true,
  page: 1,
  libraryEntries: [],
  canGoBack: Em.computed.gt('page', 1),
  canGoForward: true,

  fetchPage: function(page) {
    var store = this.get('targetObject.store')
        self = this;

    this.set('page', page);
    this.set('loading', true);

    store.find('libraryEntry', {recent: true, page: page}).then(function(entries) {
      self.set('libraryEntries', entries);
      self.set('loading', false);
    });
  },

  fetchFirstPage: function() {
    this.fetchPage(1);
  }.on('didInsertElement'),

  actions: {
    goBack: function() {
      if (!this.get('canGoBack')) { return; }
      alert("TODO");
    },

    goForward: function() {
      if (!this.get('canGoForward')) { return; }
      alert("TODO");
    }
  }
});
