import Mixin from 'ember-metal/mixin';
import get from 'ember-metal/get';

export default Mixin.create({
  actions: {
    error(reason) {
      const status = get(reason, 'errors.firstObject.status');
      if (status === '500') {
        this.replaceWith('server-error');
      } else {
        console.error(reason);
        //this.replaceWith('/404');
      }
    }
  }
});
