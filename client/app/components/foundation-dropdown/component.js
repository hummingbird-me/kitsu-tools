import Component from 'ember-component';
import { scheduleOnce } from 'ember-runloop';
import get from 'ember-metal/get';

export default Component.extend({
  dropdownId: undefined,

  didInsertElement() {
    this._super(...arguments);
    scheduleOnce('afterRender', this, () => {
      this.$().foundation();

      if (get(this, 'closeOnClick') === true) {
        this.$('.dropdown-pane').on('click', () => {
          this.$('.dropdown-pane').foundation('close');
        });
      }
    });
  },

  willDestroyElement() {
    this._super(...arguments);
    if (get(this, 'closeOnClick') === true) {
      this.$('.dropdown-pane').off('click');
    }
  }
});
