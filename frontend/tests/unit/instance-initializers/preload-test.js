import Ember from 'ember';
import { initialize } from 'frontend/instance-initializers/preload';

var appInstance;

module('PreloadInitializer', {
  setup: function() {
    Ember.run(function() {
      var application = Ember.Application.create();
      appInstance = application.__deprecatedInstance__;
      application.deferReadiness();
    });
  }
});

// Replace this with your real tests.
test('it works', function(assert) {
  initialize(appInstance);

  // you would normally confirm the results of the initializer here
  assert.ok(true);
});
