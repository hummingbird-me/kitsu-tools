HB.HeaderController = Ember.Controller.extend(HB.HasCurrentUser, {
  needs: ['application'],

  showUpdater: false,
  showMenu: false,
  unreadNotifications: 0,
  resentEmail: false,

  allowQuickUpdate: function() {
    return this.get('currentUser.isSignedIn') && this.get('controllers.application.currentRouteName') !== "dashboard";
  }.property('controllers.application.currentRouteName', 'currentUser.isSignedIn'),

  hasUnreadNotifications: function () {
    return this.get('unreadNotifications') !== 0;
  }.property('unreadNotifications'),
  limitedNotifications: [],

  blotter: HB.PreloadStore.get('blotter'),
  showBlotter: function () {
    return this.get('blotter.message') && (window.localStorage.dismissedBlotter != this.get('blotter.message'));
  }.property('blotter.message'),

  unconfirmed: Ember.computed.equal('currentUser.confirmed', false),

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
    toggleMenu: function () {
      this.toggleProperty('showMenu');
    },
    dismissBlotter: function () {
      window.localStorage.dismissedBlotter = this.get('blotter.message');
      this.notifyPropertyChange('showBlotter');
    },
    resendEmail: function () {
      var self = this;
      this.set('resentEmail', false);
      ic.ajax({
        url: '/settings/resend_confirmation',
        type: 'POST'
      }).then(function() {
        self.set('resentEmail', true);
      });
    }
  }
});
