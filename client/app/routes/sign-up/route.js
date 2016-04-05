import Route from 'ember-route';
import get, { getProperties } from 'ember-metal/get';
import set from 'ember-metal/set';
import service from 'ember-service/inject';
import UnauthenticatedRouteMixin from 'ember-simple-auth/mixins/unauthenticated-route-mixin';
import errorMessage from 'client/utils/error-messages';

export default Route.extend(UnauthenticatedRouteMixin, {
  titleToken: 'Sign Up',
  currentSession: service(),

  model() {
    return get(this, 'store').createRecord('user');
  },

  actions: {
    createAccount() {
      const controller = get(this, 'controller');
      const model = get(controller, 'model');
      return model.save()
        .then(() => {
          const { name: identification, password } = getProperties(model, 'name', 'password');
          get(this, 'currentSession')
            .authenticateWithOAuth2(identification, password)
            .then(() => this.transitionTo('onboarding.start'))
            .catch((err) => set(controller, 'errorMessage', errorMessage(err)));
        })
        .catch((err) => set(controller, 'errorMessage', errorMessage(err)));
    }
  }
});
