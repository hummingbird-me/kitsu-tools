import Route from 'ember-route';
import UnauthenticatedRouteMixin from 'ember-simple-auth/mixins/unauthenticated-route-mixin';

export default Route.extend(UnauthenticatedRouteMixin, {
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
