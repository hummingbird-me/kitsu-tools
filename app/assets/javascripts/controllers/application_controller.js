Hummingbird.ApplicationController = Ember.Controller.extend(Hummingbird.HasCurrentUser, {
  needs: ['header'],

  routeChanged: function () {
    // Track the last visited URL for redirection on sign in.
    if (!window.location.href.match('/sign-in')) {
      window.lastVisitedURL = window.location.href;
    }

    // Track Google Analytics page view.
    if (window._gaq) {
      if (this.afterFirstHit) {
        Em.run.schedule('afterRender', function() {
          _gaq.push(['_trackPageview']);
        });
      } else {
        this.afterFirstHit = true;
      }
    }
  }.observes('currentPath'),

  // Close the quick update panel on page transition.
  closeQuickUpdate: function() {
    this.set('controllers.header.showUpdater', false);
  }.observes('currentPath'),

  actions: {
    signOut: function () {
      Hummingbird.Session.signOut();
    }
  }
});
