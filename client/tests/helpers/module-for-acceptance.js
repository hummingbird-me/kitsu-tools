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
        // jscs:disable
        return options.beforeEach.apply(this, arguments);
        // jscs:enable
      }
    },

    afterEach() {
      // jscs:disable
      const afterEach = options.afterEach && options.afterEach.apply(this, arguments);
      // jscs:enable
      return Promise.resolve(afterEach).then(() => destroyApp(this.application));
    }
  });
}
