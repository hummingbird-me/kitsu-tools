Hummingbird.DashboardController = Ember.Controller.extend({
  init: function () {
    this.send("setupQuickUpdate");
  },
});
