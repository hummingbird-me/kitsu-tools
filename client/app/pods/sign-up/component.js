import Ember from 'ember';
import EmberValidations, { validator } from 'ember-validations';
import { RoutableComponentMixin } from 'client/mixins/routable-component';

const { Component, isPresent, computed } = Ember;

export default Component.extend(EmberValidations, RoutableComponentMixin, {
  email: null,
  username: null,
  password: null,
  errorMessage: null,
  validations: {
    'email': {
      presence: true
    },
    'username': {
      presence: true,
      format: { with: /^[_a-zA-Z0-9]+$/, message: 'must be letters, numbers, and underscores only' },
      length: { minimum: 3, maximum: 20 },
      inline: validator(function() {
        // must not be all numbers
        if (isPresent(this.get('username')) && /^[0-9]+$/.test(this.get('username'))) {
          return 'must not be entirely numbers';
        }

        // start with a letter, or number
        if (isPresent(this.get('username')) && !/^[a-zA-Z0-9]$/.test(this.get('username').charAt(0))) {
          return 'must start with a letter or number';
        }
      })
    },
    'password': {
      presence: true,
      length: { minimum: 8 }
    }
  },

  isSubmitDisabled: computed.not('isValid'),

  actions: {
    createAccount() {
      // TODO: send request upstream & figure out auth flow
    }
  }
});
