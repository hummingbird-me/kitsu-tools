import Route from 'ember-route';
import UnauthenticatedRouteMixin from 'ember-simple-auth/mixins/unauthenticated-route-mixin';

export default Route.extend(UnauthenticatedRouteMixin, {
  titleToken: 'Sign Up',

  model() {
    return this.store.createRecord('user');
  },

  setupController(controller) {
    this._super(...arguments);
    controller.setProperties({
      errorMessage: null
    });
  }
});
