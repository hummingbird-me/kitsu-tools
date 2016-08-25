import Component from 'ember-component';
import get from 'ember-metal/get';

export default Component.extend({
  tagName: 'li',

  actions: {
    changeStatus() {
      if (get(this, 'isActive')) {
        return;
      }
      const status = get(this, 'status');
      get(this, 'onClick')(status);
    }
  }
});
