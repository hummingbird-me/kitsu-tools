Hummingbird.SettingsRoute = Ember.Route.extend({
  afterModel: function(resolvedModel) {
    return Hummingbird.TitleManager.setTitle('Settings');
  },
  actions: {
    willTransition: function(transition) {
      this.controller.send('clean');
      return true;
    },
  }
});
