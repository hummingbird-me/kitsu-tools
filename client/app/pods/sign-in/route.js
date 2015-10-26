import Ember from 'ember';
import UnauthenticatedRouteMixin from 'ember-simple-auth/mixins/unauthenticated-route-mixin';

export default Ember.Route.extend(UnauthenticatedRouteMixin, {
  titleToken: 'Sign In',

  setupController(controller) {
    this._super(...arguments);
    controller.setProperties({
      identification: null,
      password: null,
      errorMessage: null
    });
  }
});
