import Component from 'ember-component';
import get from 'ember-metal/get';
import libraryStatus from 'client/utils/library-status';

export default Component.extend({
  tagName: 'li',

  actions: {
    changeStatus() {
      if (get(this, 'isActive')) {
        return;
      }
      const status = get(this, 'status');
      get(this, 'onClick')(libraryStatus.enumToNumber(status.key));
    }
  }
});
