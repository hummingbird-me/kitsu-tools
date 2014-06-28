Hummingbird.DashboardController = Ember.Controller.extend(Hummingbird.HasCurrentUser, {
  init: function () {
    this.send("setupQuickUpdate");
  },
});
