import Ember from 'ember';
import { RoutableComponentMixin } from 'client/mixins/routable-component';

const {
  Component,
  isEmpty,
  computed,
  get,
  getProperties,
  set,
  inject: { service }
} = Ember;

export default Component.extend(RoutableComponentMixin, {
  identification: null,
  password: null,
  errorMessage: null,
  session: service(),

  isSubmitDisabled: computed('identification', 'password', function() {
    return isEmpty(get(this, 'identification')) || isEmpty(get(this, 'password'));
  }),

  actions: {
    authenticateWithOAuth2() {
      const data = getProperties(this, 'identification', 'password');
      get(this, 'session').authenticate('authenticator:oauth2', data).catch((reason) => {
        // TODO: This returns errors from http://tools.ietf.org/html/rfc6749#section-5.2
        // should be made more human friendly.
        set(this, 'errorMessage', reason.error);
      });
    }
  }
});
