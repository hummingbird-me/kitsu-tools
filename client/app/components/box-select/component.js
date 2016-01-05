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

/*
  {{box-select
    selection=allStreamers
    selected=streamers
    onSelect=(action (mut streamers))
  }}
*/

export default Component.extend({
  options: computed({
    get() {
      const { selection, selected } = getProperties(this, 'selection', 'selected');
      return selection.map((option) => {
        const out = merge({}, option);
        set(out, 'selected', selected.contains(option.key));
        return out;
      });
    }
  }),

  actions: {
    toggle(option) {
      // Copy so we aren't actually mutating the variable
      let value = copy(get(this, 'selected'));
      if (value.contains(option.key)) {
        value.removeObject(option.key);
      } else {
        value.addObject(option.key);
      }
      get(this, 'onSelect')(value);
    }
  }
});
