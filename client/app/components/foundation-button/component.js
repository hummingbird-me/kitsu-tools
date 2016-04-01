import Component from 'ember-component';

export default Component.extend({
  tagName: 'button',
  classNames: ['button'],
  attributeBindings: ['type', 'data-toggle', 'data-test-selector'],

  type: 'button'
});
