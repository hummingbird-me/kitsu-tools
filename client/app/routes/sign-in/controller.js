import Controller from 'ember-controller';
import { isEmpty } from 'ember-utils';
import computed from 'ember-computed';
import get, { getProperties } from 'ember-metal/get';
import set from 'ember-metal/set';
import service from 'ember-service/inject';
import errorMessages from 'client/utils/error-messages';

export default Controller.extend({
  currentSession: service(),

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
