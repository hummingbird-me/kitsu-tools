HB.LoadingRoute = Ember.Route.extend({
  activate: function() {
    this._super();
    Pace.restart();
  },

  deactivate: function() {
    this._super();
    Pace.stop();
  }
});
