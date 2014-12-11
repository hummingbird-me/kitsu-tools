import Ember from 'ember';
import PreloadStore from '../utils/preload-store';
import HasCurrentUser from '../mixins/has-current-user';
import ic from 'ic-ajax';

export default Ember.Controller.extend(HasCurrentUser, {
  needs: ['application', 'notifications'],
  notifications: Ember.computed.alias('controllers.notifications'),

  showUpdater: false,
  showMenu: false,
  resentEmail: false,

  allowQuickUpdate: function() {
    return this.get('currentUser.isSignedIn') &&
           this.get('controllers.application.currentRouteName') !== "dashboard";
  }.property('controllers.application.currentRouteName', 'currentUser.isSignedIn'),

  unreadNotifications: Ember.computed.filterBy('notifications', 'seen', false),
  unreadNotificationsCount: Ember.computed.alias('unreadNotifications.length'),
  hasUnreadNotifications: Ember.computed.notEmpty('unreadNotifications'),
  limitedNotifications: function () {
    return this.get('notifications').slice(0, 3);
  }.property('notifications.@each'),

  blotter: PreloadStore.get('blotter'),
  showBlotter: function () {
    return this.get('blotter.message') &&
           window.localStorage.dismissedBlotter !== this.get('blotter.message');
  }.property('blotter.message'),

  unconfirmed: Ember.computed.equal('currentUser.confirmed', false),

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
