HB.AppsMineRoute = Ember.Route.extend({
  model: function() {
    // TODO: swap this for an actual query
    return this.store.find('app', { creator: window.currentUserName });
  }
});
