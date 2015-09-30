import Ember from 'ember';

const { GlimmerComponent, on } = Ember;

export default GlimmerComponent.extend({
  'data-alert': '',
  type: '',
  closable: true,
  classNameBindings: ['attrs.type'],
  attributeBindings: ['data-alert'],

  _initializeFoundation: on('didInsertElement', function() {
    this.$().parent().foundation();
  })
});
