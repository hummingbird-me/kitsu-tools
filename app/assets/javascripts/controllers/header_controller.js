Hummingbird.HeaderController = Ember.Controller.extend({
  unreadNotifications: 0,
  hasUnreadNotifications: function () {
    return this.get('unreadNotifications') !== 0;
  }.property('unreadNotifications'),
  showSearchbar: false,
  limitedNotifications: [],
  entriesLoaded: function () {
    return this.get('recentLibraryEntries');
  }.property('recentLibraryEntries.@each'),
  firstEntry: function () {
    if (this.get('recentLibraryEntries')) {
      return this.get('recentLibraryEntries.firstObject.id');
    } else {
      return false;
    }
  }.property('recentLibraryEntries.@each'),
  init: function () {
    var _this = this;
    var bloodhound = new Bloodhound({
      datumTokenizer: function (d) {
        return Bloodhound.tokenizers.whitespace(d.value);
      },
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      limit: 6,
      remote: {
        url: '/search.json?query=%QUERY&type=mixed',
        filter: function (results) {
          return Ember.$.map(results.search, function (r) {
            // There actually has to be a way to send the img params to the thumb generator in the request, this is just a temp. solution
            if (r.type=="user") {
              r.image = r.image.replace(/(\.[a-zA-Z]+)?\?/, ".jpg?")
            }
            return {
              title: r.title,
              type: r.type,
              image: r.image.replace((r.type=="user"?"{size}":"large"), (r.type=="user"?"small":"medium")),
              link: r.link
            };
          });
        }
      }
    });
    bloodhound.initialize();
    this.set('bhInstance', bloodhound);
    this.store.find('notification').then(function (result) {
      var newOnes, notif, _i, _len, _ref;
      newOnes = 0;
      _ref = result.get('content');
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        notif = _ref[_i];
        if (notif.get('seen') === false) {
          newOnes++;
        }
      }
      _this.set('unreadNotifications', newOnes);
      return _this.set('limitedNotifications', result.slice(0, 3));
    });
    return this._super();
  },
  instantSearchResults: [],
  hasInstantSearchResults: function () {
    return this.get('instantSearchResults').length !== 0 && this.get('searchTerm').length !== 0;
  }.property('instantSearchResults'),
  instantSearch: function () {
    var blodhound, searchterm,
      _this = this;
    blodhound = this.get('bhInstance');
    searchterm = this.get('searchTerm');
    return blodhound.get(searchterm, function (suggestions) {
      return _this.set('instantSearchResults', suggestions);
    });
  }.observes('searchTerm'),
  showUpdater: false,
  recentLibraryEntries: [],
  actions: {
    showSearchfield: function () {
      this.set('showSearchbar', true);
      this.set('instantSearchResults', []);
    },
    hideSearchfield: function () {
      return Ember.run.later(this, (function () {
        return this.set('showSearchbar', false);
      }), 100);
    },
    submitSearch: function () {
      return window.location.replace("http://hummingbird.me/search?query=" + this.get('searchTerm'));
    },
    toggleUpdater: function () {
      var _this = this;
      // refreshes the list for the quick update
      this.toggleProperty('showUpdater');
      if (this.get('showUpdater') === false) {
        Ember.run.later(this, (function () {
          return _this.send('setupQuickUpdate');
        }), 10);
      }
      return false;
    }
  }
});
