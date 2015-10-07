import Ember from 'ember';
import EmberValidations, { validator } from 'ember-validations';
import { RoutableComponentMixin } from 'client/mixins/routable-component';
import errorMessages from 'client/utils/error-messages';

const {
  Component,
  isPresent,
  get,
  set,
  getProperties,
  computed,
  inject: { service }
} = Ember;

export default Component.extend(EmberValidations, RoutableComponentMixin, {
  currentSession: service(),
  errorMessage: null,
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
      get(this, 'model').save().then(() => {
        const { identification, password } = getProperties(this, 'model.name', 'model.password');
        get(this, 'currentSession').authenticateWithOAuth2(identification, password)
          .catch((reason) => {
            set(this, 'errorMessage', errorMessages(reason));
          });
      }).catch((reason) => {
        set(this, 'errorMessage', errorMessages(reason));
      });
    }
  }
});
