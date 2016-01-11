import Component from 'ember-one-way-controls/components/one-way-input';

export default Component.extend({
  attributeBindings: ['data-test-selector', 'readonly'],

  // Input values are handled as strings, so when we bind to an Ember-Data
  // property that passes down an integer it causes another update to happen
  // as this component compares the new value to the old value (int === str).
  sanitizeInput(input) {
    const value = parseInt(input, 10);
    return isNaN(value) ? input : value;
  }
});
