import Component from 'ember-component';
import get from 'ember-metal/get';

export default Component.extend({
  actions: {
    select() {
      const option = get(this, 'option');
      get(this, 'onSelect')(option);
    }
  }
});
