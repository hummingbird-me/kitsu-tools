import Component from 'ember-component';
import get from 'ember-metal/get';
import { copy } from 'ember-metal/utils';

export default Component.extend({
  actions: {
    toggle(option) {
      const value = copy(get(this, 'selected'));
      if (value.includes(option)) {
        value.removeObject(option);
      } else {
        value.addObject(option);
      }
      get(this, 'onSelect')(value);
    }
  }
});
