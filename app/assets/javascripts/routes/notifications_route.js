Hummingbird.NotificationsRoute = Ember.Route.extend({
  model: function() {
    return this.store.find('notification');
  }
});
