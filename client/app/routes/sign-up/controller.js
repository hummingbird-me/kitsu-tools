import Controller from 'ember-controller';
import get from 'ember-metal/get';
import { alias } from 'ember-computed';
import EmberValidations, { validator } from 'ember-validations';
import { isPresent } from 'ember-utils';

export default Controller.extend(EmberValidations, {
  user: alias('model'),

  validations: {
    'user.email': {
      presence: true,
      format: {
        with: /^[^@]+@([^@\.]+\.)+[^@\.]+$/,
        message: 'must be a valid email address'
      }
    },
    'user.name': {
      presence: true,
      format: {
        with: /^[_a-zA-Z0-9]+$/,
        message: 'must use letters, numbers, and underscores only'
      },
      length: { minimum: 3, maximum: 20 },
      inline: validator(function() {
        const name = get(get(this, 'model'), 'user.name');
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
    'user.password': {
      presence: true,
      length: { minimum: 8 }
    }
  }
});
