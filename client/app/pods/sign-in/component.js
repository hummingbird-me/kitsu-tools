import Ember from 'ember';
import { RoutableComponentMixin } from 'client/mixins/routable-component';

const { Component, inject, isEmpty, computed } = Ember;
const { service } = inject;

export default Component.extend(RoutableComponentMixin, {
  identification: null,
  password: null,
  errorMessage: null,
  session: service(),

  isSubmitDisabled: computed('identification', 'password', function() {
    return isEmpty(this.get('identification')) ||
      isEmpty(this.get('password'));
  }),

  actions: {
    authenticateWithOAuth2() {
      const data = this.getProperties('identification', 'password');
      this.get('session').authenticate('authenticator:oauth2', data).catch((reason) => {
        // TODO: This returns errors from http://tools.ietf.org/html/rfc6749#section-5.2
        // should be made more human friendly.
        this.set('errorMessage', reason.error);
      });
    }
  }
});
