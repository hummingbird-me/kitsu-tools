import Ember from 'ember';

const {
  Component,
  get,
  run
} = Ember;

export default Component.extend({
  modalId: undefined,
  modalClass: undefined,

  didInsertElement() {
    this._super(...arguments);
    run.scheduleOnce('afterRender', this, () => {
      const id = get(this, 'modalId');
      this.$(`#${id}`).foundation();
    });
  }
});
