import Ember from 'ember';
import errorMessages from 'client/utils/error-messages';

const {
  Controller,
  isEmpty,
  computed,
  get,
  getProperties,
  set,
  inject: { service }
} = Ember;

export default Controller.extend({
  currentSession: service(),
  identification: null,
  password: null,
  errorMessage: null,

  isSubmitDisabled: computed('identification', 'password', {
    get() {
      return isEmpty(get(this, 'identification')) || isEmpty(get(this, 'password'));
    }
  }),

  actions: {
    authenticateWithOAuth2() {
      const { identification, password } = getProperties(this, 'identification', 'password');
      get(this, 'currentSession').authenticateWithOAuth2(identification, password)
        .catch((reason) => {
          set(this, 'errorMessage', errorMessages(reason));
        });
    }
  }
});
