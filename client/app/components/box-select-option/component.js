import Ember from 'ember';

const {
  Component,
  computed: { alias },
  get
} = Ember;

export default Component.extend({
  option: undefined,
  isSelected: alias('option.selected'),

  actions: {
    toggle() {
      this.toggleProperty('isSelected');
      get(this, 'onSelect')(get(this, 'option'));
    }
  }
});
