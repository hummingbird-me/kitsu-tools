import Ember from 'ember';
import Session from '../utils/session';
import HasCurrentUser from '../mixins/has-current-user';

export default Ember.Controller.extend(HasCurrentUser, {
  needs: ['header'],

  routeChanged: function() {
    // Track the last visited URL for redirection on sign in.
    if (!window.location.href.match('/sign-in')) {
      window.lastVisitedURL = window.location.href;
    }

    // Track page view
    if (window.analytics !== undefined) {
      window.analytics.page();
    }
  }.observes('currentPath'),

  // Close the quick update panel on page transition.
  closeQuickUpdate: function() {
    this.set('controllers.header.showUpdater', false);
  }.observes('currentPath'),

  actions: {
    signOut: function () {
      Session.signOut();
    }
  }
});
