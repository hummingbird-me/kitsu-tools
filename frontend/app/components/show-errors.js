import Ember from 'ember';

export default Ember.Component.extend({
  clientErrors: [],
  serverErrors: [],
  if: true,
  fieldName: '',

  serverErrorMessages: Ember.computed.map('serverErrors', (item) => item.message),
  shouldDisplayErrors: function() {
    // Shorted so server errors are alwayd displayed
    return this.get('serverErrorMessages.length') > 0 ||
          (this.get('errors.length') && this.get('if'));
  }.property('errors.length', 'if', 'hasServerErrors'),
  errors: Ember.computed.union('clientErrors', 'serverErrorMessages'),
  hasMultipleErrors: Ember.computed.gt('errors.length', 1)
});
