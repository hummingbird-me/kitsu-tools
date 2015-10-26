import Ember from 'ember';
import EmberValidations, { validator } from 'ember-validations';
import errorMessages from 'client/utils/error-messages';

const {
  Controller,
  isPresent,
  get,
  set,
  computed,
  inject: { service }
} = Ember;

export default Controller.extend(EmberValidations, {
  currentSession: service(),
  validations: {
    'model.email': {
      presence: true,
      format: { with: /^[^@]+@([^@\.]+\.)+[^@\.]+$/, message: 'must be a valid email address' }
    },
    'model.name': {
      presence: true,
      format: { with: /^[_a-zA-Z0-9]+$/, message: 'must be letters, numbers, and underscores only' },
      length: { minimum: 3, maximum: 20 },
      inline: validator(function() {
        const name = get(this.model, 'model.name');
        // must not be all numbers
        if (isPresent(name) && /^[0-9]+$/.test(name)) {
          return 'must not be entirely numbers';
        }

        // start with a letter, or number
        if (isPresent(name) && !/^[a-zA-Z0-9]$/.test(name.charAt(0))) {
          return 'must start with a letter or number';
        }
      })
    },
    'model.password': {
      presence: true,
      length: { minimum: 8 }
    }
  },

  isSubmitDisabled: computed.not('isValid'),

  actions: {
    createAccount() {
      get(this, 'model').save()
        .then(() => {
          const identification = get(this, 'model.name');
          const password = get(this, 'model.password');
          get(this, 'currentSession').authenticateWithOAuth2(identification, password)
            .then(() => {
              this.transitionToRoute('onboarding.start');
            })
            .catch((reason) => {
              set(this, 'errorMessage', errorMessages(reason));
            });
        })
        .catch((reason) => {
          set(this, 'errorMessage', errorMessages(reason));
        });
    }
  }
});
