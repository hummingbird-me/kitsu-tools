import Ember from 'ember';
import EmberValidations, { validator } from 'ember-validations';
import { RoutableComponentMixin } from 'client/mixins/routable-component';
import errorMessages from 'client/utils/error-messages';

const {
  Component,
  isPresent,
  get,
  set,
  computed
} = Ember;

export default Component.extend(EmberValidations, RoutableComponentMixin, {
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
        // TODO: send off a token request, get rid of local password
        // TODO: transition to onboarding
        this.transitionToRoute('dashboard');
      }).catch((reason) => {
        set(this, 'errorMessage', errorMessages(reason));
      });
    }
  }
});
