Hummingbird.SettingsRoute = Ember.Route.extend({
  model: function() {
    return this.get('currentUser');
  }
});
