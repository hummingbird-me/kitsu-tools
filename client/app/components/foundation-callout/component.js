import Ember from 'ember';

const {
  Component,
  run,
  get
} = Ember;

// Let Foundation handle closing the callout due to additonal animations.
// Cleanup the component after the fact.
export default Component.extend({
  type: null,
  closable: false,

  didInsertElement() {
    if (get(this, 'closable') === true) {
      run.scheduleOnce('afterRender', this, () => {
        this.$().on('closed.zf', () => this.destroy());
      });
    }
  },

  willDestroyElement() {
    if (get(this, 'closable') === true) {
      this.$().off('closed.zf');
    }
  }
});
