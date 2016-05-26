import Route from 'ember-route';
import get, { getProperties } from 'ember-metal/get';
import set, { setProperties } from 'ember-metal/set';
import service from 'ember-service/inject';
import errorMessage from 'client/utils/error-messages';
import UnauthenticatedRouteMixin from 'ember-simple-auth/mixins/unauthenticated-route-mixin';

// CLEANUP: Routable Components
export default Route.extend(UnauthenticatedRouteMixin, {
  currentSession: service(),

  resetController(controller) {
    this._super(...arguments);
    setProperties(controller, {
      identification: undefined,
      password: undefined,
      errorMessage: undefined
    });
  },

  actions: {
    auth() {
      const controller = get(this, 'controller');
      const { identification, password } =
        getProperties(controller, 'identification', 'password');
      get(this, 'currentSession')
        .authenticateWithOAuth2(identification, password)
        .catch((err) => set(controller, 'errorMessage', errorMessage(err)));
    }
  }
});
