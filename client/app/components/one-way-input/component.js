/*
  Data down, actions up is the new Ember.js way™. This allows us to achieve that
  when using inputs.

  @Example: {{one-way-input value=myValue update=(action (mut myValue))}}
*/
import Ember from 'ember';

const {
  Component,
  get,
  on
} = Ember;

export default Component.extend({
  tagName: 'input',
  attributeBindings: ['type', 'value', 'placeholder', 'name', 'data-test-selector'],
  type: 'text',

  _onChange: on('input', 'change', function() {
    this._handleChangeEvent();
  }),

  didReceiveAttrs() {
    if (!get(this, 'attrs.update')) {
      throw new Error(`You must provide an \`update\` action to \`{{one-way-input}}\`.`);
    }
    this._handleUpdate(get(this, 'value'));
  },

  _handleChangeEvent() {
    const value = this.readDOMAttr('value');
    this._handleUpdate(value);
  },

  _handleUpdate(value) {
    get(this, 'attrs').update(value);
  }
});
