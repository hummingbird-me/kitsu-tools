import Component from 'ember-component';
import get, { getProperties } from 'ember-metal/get';
import set from 'ember-metal/set';
import computed from 'ember-computed';
import { assign } from 'ember-platform';
import { copy } from 'ember-metal/utils';

export default Component.extend({
  selection: [],
  selected: [],

  options: computed({
    get() {
      const { selection, selected } = getProperties(this, 'selection', 'selected');
      return selection.map((option) => {
        const out = assign({}, { name: option });
        set(out, 'selected', selected.contains(option));
        return out;
      });
    }
  }),

  actions: {
    toggle(option) {
      // Copy so we aren't actually mutating the variable
      const value = copy(get(this, 'selected'));
      if (value.contains(option.name)) {
        value.removeObject(option.name);
      } else {
        value.addObject(option.name);
      }
      get(this, 'onSelect')(value);
    }
  }
});
