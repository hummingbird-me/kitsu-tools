import Ember from 'ember';

const {
  Component,
  on,
  run,
  get
} = Ember;

// Let Foundation handle closing the alert box due to additonal animations.
// Cleanup the component after the fact.
export default Component.extend({
  type: null,
  closable: false,

  _initializeFoundation: on('didInsertElement', function() {
    if (get(this, 'closable') === true) {
      run.scheduleOnce('afterRender', this, () => {
        this.$().foundation('alert', 'reflow');
        this.$().on('close.fndtn.alert', () => this.destroy());
      });
    }
  }),

  _cleanupFoundation: on('willDestroyElement', function() {
    if (get(this, 'closable') === true) {
      this.$().off('close.fndtn.alert');
    }
  })
});
