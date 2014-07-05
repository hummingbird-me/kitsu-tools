Hummingbird.HeaderController = Ember.Controller.extend(Hummingbird.HasCurrentUser, {
  unreadNotifications: 0,
  hasUnreadNotifications: function () {
    return this.get('unreadNotifications') !== 0;
  }.property('unreadNotifications'),
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
  showUpdater: false,
  showMenu: false,
  recentLibraryEntries: [],
  actions: {
    submitSearch: function () {
      return window.location.replace("/search?query=" + this.get('searchTerm'));
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
    },
    toggleMenu: function(){
      this.toggleProperty('showMenu');
    }
  }
});
