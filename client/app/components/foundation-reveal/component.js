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
    run.scheduleOnce('afterRender', this, () => {
      const id = get(this, 'modalId');
      this.$(`#${id}`).foundation();
    });
  }
});
