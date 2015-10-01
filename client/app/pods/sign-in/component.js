import Ember from 'ember';
import { RoutableComponentMixin } from 'client/mixins/routable-component';
import errorMessages from 'client/utils/error-messages';

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
  currentSession: service(),
  identification: null,
  password: null,
  errorMessage: null,

  isSubmitDisabled: computed('identification', 'password', function() {
    return isEmpty(get(this, 'identification')) || isEmpty(get(this, 'password'));
  }),

  actions: {
    authenticateWithOAuth2() {
      const data = getProperties(this, 'identification', 'password');
      get(this, 'currentSession').authenticateWithOAuth2(data).catch((reason) => {
        set(this, 'errorMessage', errorMessages(reason));
      });
    }
  }
});
