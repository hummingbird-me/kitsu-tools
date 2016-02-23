import { module } from 'qunit';
import startApp from 'client/tests/helpers/start-app';
import destroyApp from 'client/tests/helpers/destroy-app';

export default function(name, options = {}) {
  module(name, {
    beforeEach() {
      this.application = startApp();

      if (options.beforeEach) {
        // jscs:disable
        options.beforeEach.apply(this, arguments);
        // jscs:enable
      }
    },

    afterEach() {
      destroyApp(this.application);

      if (options.afterEach) {
        // jscs:disable
        options.afterEach.apply(this, arguments);
        // jscs:enable
      }
    }
  });
}
