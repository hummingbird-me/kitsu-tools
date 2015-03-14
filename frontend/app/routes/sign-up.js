import Ember from 'ember';

export default Ember.Route.extend({
  beforeModel: function() {
    if (this.get('currentUser.isSignedIn')) {
      this.transitionTo('dashboard');
    }
  },

  setupController: function(controller) {
    controller.setProperties({
      'email': '',
      'username': '',
      'password': '',
      'errorMessage': ''
    });
  }
});
