import Component from 'ember-component';
import computed from 'ember-computed';
import get from 'ember-metal/get';

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
