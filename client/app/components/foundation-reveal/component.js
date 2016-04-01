import Component from 'ember-component';
import { scheduleOnce } from 'ember-runloop';
import get from 'ember-metal/get';

export default Component.extend({
  modalId: undefined,
  modalClass: undefined,

  didInsertElement() {
    this._super(...arguments);
    scheduleOnce('afterRender', this, () => {
      const id = get(this, 'modalId');
      this.$(`#${id}`).foundation();
    });
  }
});
