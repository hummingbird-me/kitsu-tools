import Ember from 'ember';

const {
  GlimmerComponent,
  on,
  run
} = Ember;

export default GlimmerComponent.extend({
  'data-alert': '',
  type: '',
  closable: true,
  classNameBindings: ['attrs.type'],
  attributeBindings: ['data-alert'],

  _initializeFoundation: on('didInsertElement', function() {
    run.scheduleOnce('afterRender', this, () => {
      this.$().parent().foundation();
    });
  })
});
