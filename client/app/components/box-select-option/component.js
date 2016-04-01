import Component from 'ember-component';
import { alias } from 'ember-computed';
import get from 'ember-metal/get';

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
