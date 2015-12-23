import Ember from 'ember';

const {
  Component,
  computed,
  get
} = Ember;

// TODO: Support showing time
export default Component.extend({
  stats: computed('section', {
    get() {
      const entries = get(this, 'section.entries');
      const count = entries !== undefined ? entries.length : 0;
      return `${count} titles`;
    }
  })
});
