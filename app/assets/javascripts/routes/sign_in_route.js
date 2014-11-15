HB.SignInRoute = Ember.Route.extend({
  beforeModel: function() {
    if (this.get('currentUser.isSignedIn')) {
      this.transitionTo('dashboard');
    }
  },
  setupController: function(controller, model) {
    controller.set('username', '');
    controller.set('password', '');
    controller.set('errorMessage', '');
  }
});
