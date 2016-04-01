import Ember from 'ember';

const {
  Component,
  run,
  get
} = Ember;

export default Component.extend({
  attributeBindings: ['style'],
  style: 'position: absolute;',
  dropdownId: undefined,

  didInsertElement() {
    this._super(...arguments);
    run.scheduleOnce('afterRender', this, () => {
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
