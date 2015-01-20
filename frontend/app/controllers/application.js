import Ember from 'ember';
import Session from '../utils/session';

export default Ember.Controller.extend({
  needs: ['header'],

  // use location here as currentPath will have
  // multiple values before hitting 'index'
  landingPage: function() {
    return window.location.pathname === '/';
  }.property('currentPath'),
  
  showSignUpCta: function() {
    return !this.get('landingPage') && !this.get('currentUser.isSignedIn');
  }.property('landingPage', 'currentUser.isSignedIn'),

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
