import Ember from 'ember';
import EmberValidations, { validator } from 'ember-validations';
import { RoutableComponentMixin } from 'client/mixins/routable-component';

const { Component, isPresent, computed } = Ember;

export default Component.extend(EmberValidations, RoutableComponentMixin, {
  errorMessage: null,
  validations: {
    'model.email': {
      presence: true
    },
    'model.username': {
      presence: true,
      format: { with: /^[_a-zA-Z0-9]+$/, message: 'must be letters, numbers, and underscores only' },
      length: { minimum: 3, maximum: 20 },
      inline: validator(function() {
        let username = this.model.get('model.username');
        // must not be all numbers
        if (isPresent(username) && /^[0-9]+$/.test(username)) {
          return 'must not be entirely numbers';
        }

        // start with a letter, or number
        if (isPresent(username) && !/^[a-zA-Z0-9]$/.test(username.charAt(0))) {
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
      this.get('model').save().then(() => {
        // TODO: send off a token request, get rid of local password
        // TODO: transition to onboarding
        this.transitionToRoute('dashboard');
      }).catch((error) => {
        const reason = error.message ? error.message : 'An unknown error occurred';
        this.set('errorMessage', reason);
      });
    }
  }
});
