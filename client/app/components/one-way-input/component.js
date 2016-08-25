import Component from 'ember-one-way-controls/components/one-way-input';

export default Component.extend({
  attributeBindings: ['data-test-selector', 'readonly'],

  /**
   * Convert values that are actually integers to be integers rathern than
   * strings
   */
  sanitizeInput(input) {
    const value = parseInt(input, 10);
    return isNaN(value) || value.toString().length !== input.length ? input : value;
  }
});
