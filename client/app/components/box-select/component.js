import Ember from 'ember';

const {
  Component,
  get,
  set,
  getProperties,
  computed,
  merge,
  copy
} = Ember;

export default Component.extend({
  selection: [],
  selected: [],

  options: computed({
    get() {
      const { selection, selected } = getProperties(this, 'selection', 'selected');
      return selection.map((option) => {
        const out = merge({}, { name: option });
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
