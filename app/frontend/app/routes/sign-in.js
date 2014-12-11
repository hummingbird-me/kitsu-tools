import Ember from 'ember';

export default Ember.Route.extend({
  beforeModel: function() {
    if (this.get('currentUser.isSignedIn')) {
      this.transitionTo('dashboard');
    }
  },

  setupController: function(controller) {
    controller.set('username', '');
    controller.set('password', '');
    controller.set('errorMessage', '');
  }
});
