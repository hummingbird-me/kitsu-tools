import Ember from 'ember';

const {
  Component,
  computed,
  get
} = Ember;

export default Component.extend({
  tagName: 'li',

  isActive: computed('current', 'status', {
    get() {
      return get(this, 'current') === get(this, 'status');
    }
  }),

  actions: {
    changeStatus(status) {
      get(this, 'onClick')(status);
    }
  }
});
