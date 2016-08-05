import { module } from 'qunit';
import startApp from 'client/tests/helpers/start-app';
import destroyApp from 'client/tests/helpers/destroy-app';
import RSVP from 'rsvp';

const { Promise } = RSVP;

export default function(name, options = {}) {
  module(name, {
    beforeEach() {
      this.application = startApp();

      if (options.beforeEach) {
        return options.beforeEach.apply(this, arguments);
      }
    },

    afterEach() {
      const afterEach = options.afterEach && options.afterEach.apply(this, arguments);
      return Promise.resolve(afterEach).then(() => destroyApp(this.application));
    }
  });
}
