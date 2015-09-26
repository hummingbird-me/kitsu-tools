import Ember from 'ember';

const { GlimmerComponent, computed, on } = Ember;

export default GlimmerComponent.extend({
  'data-alert': '',
  type: '',
  closable: true,
  classNameBindings: ['attrs.type'],
  attributeBindings: ['data-alert'],

  // `closable` is converted to a string
  showClose: computed('attrs.closable', function() {
    return this.get('attrs.closable').toString() === 'true';
  }),

  _initializeFoundation: on('didInsertElement', function() {
    this.$().parent().foundation();
  })
});
