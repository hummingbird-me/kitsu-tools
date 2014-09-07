Hummingbird.SettingsRoute = Ember.Route.extend({
  model: function() {
    return window.$NIG = this.store.find('current_user');
  }
});
