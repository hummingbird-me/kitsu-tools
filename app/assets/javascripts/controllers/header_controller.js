Hummingbird.HeaderController = Ember.Controller.extend(Hummingbird.HasCurrentUser, {
  needs: ['application'],

  showUpdater: false,
  showMenu: false,
  unreadNotifications: 0,

  allowQuickUpdate: function() {
    return this.get('currentUser.isSignedIn') && this.get('controllers.application.currentRouteName') !== "dashboard";
  }.property('controllers.application.currentRouteName', 'currentUser.isSignedIn'),

  hasUnreadNotifications: function () {
    return this.get('unreadNotifications') !== 0;
  }.property('unreadNotifications'),
  limitedNotifications: [],
  broadcast: {
    icon: 'fa-exclamation-circle',
    message: 'Forums are back! If you can\'t access them, please clear your cache.',
    link: 'http://en.wikipedia.org/wiki/Wikipedia:Bypass_your_cache#Cache_clearing_and_disabling'
  },
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

  actions: {
    submitSearch: function () {
      return window.location.replace("/search?query=" + this.get('searchTerm'));
    },
    toggleUpdater: function () {
      this.toggleProperty('showUpdater');
    },
    toggleMenu: function(){
      this.toggleProperty('showMenu');
    }
  }
});
