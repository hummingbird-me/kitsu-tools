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

    store.find('libraryEntry', {recent: true, page: page}).then(function(entries) {
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
