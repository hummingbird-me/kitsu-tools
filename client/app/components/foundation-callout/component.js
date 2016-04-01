import Component from 'ember-component';
import { scheduleOnce } from 'ember-runloop';
import get from 'ember-metal/get';

// Let Foundation handle closing the callout due to additonal animations.
// Cleanup the component after the fact.
export default Component.extend({
  type: null,
  closable: false,

  didInsertElement() {
    this._super(...arguments);
    if (get(this, 'closable') === true) {
      scheduleOnce('afterRender', this, () => {
        this.$().on('closed.zf', () => this.destroy());
      });
    }
  },

  willDestroyElement() {
    this._super(...arguments);
    if (get(this, 'closable') === true) {
      this.$().off('closed.zf');
    }
  }
});
