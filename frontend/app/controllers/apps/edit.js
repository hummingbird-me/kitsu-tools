import Ember from 'ember';
import EmberValidations from 'ember-validations';

export default Ember.Controller.extend(EmberValidations.Mixin, {
  creatingApp: false,

  validations: {
    'model.name': {
      length: {
        minimum: 5,
        maximum: 32
      }
    },
    'model.description': {
      length: { minimum: 0, maximum: 140, if: 'model.description' }
    },
    'model.redirectUri': {
      presence: { if: 'model.writeAccess' },
      format: {
        without: /^http:\/\//,
        if: 'model.writeAccess',
        message: 'cannot use http (must be https or another protocol)'
      }
    }
  },
  // When the 'if' statements change, ember-validations doesn't notice, so we
  // tell it ourselves.
  forceValidate: function() {
    this.validate();
  }.observes('model.writeAccess'),

  actions: {
    saveApp: function() {
      if (this.get('isValid')) {
        this.get('model').save().then(() => {
          this.transitionToRoute('apps.mine');
        });
      }
    }
  }
});
