import Ember from 'ember';

const { Mixin, Logger, get } = Ember;

export default Mixin.create({
  actions: {
    error(reason) {
      Logger.log(reason);
      const status = get(reason, 'errors.firstObject.status');
      if (status === '404' || status === '0' || status === undefined) {
        this.replaceWith('/404');
      } else if (status === '500') {
        this.replaceWith('/500');
      }
    }
  }
});
