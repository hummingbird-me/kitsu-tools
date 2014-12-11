import {
  moduleFor,
  test
} from 'ember-qunit';

moduleFor('controller:current-user', 'CurrentUserController', {
  // Specify the other units that are required for this test.
  // needs: ['controller:foo']
});

test('#isSignedIn', function() {
  var controller = this.subject();
  ok(!controller.get('isSignedIn'));
  controller.set('model', true);
  ok(controller.get('isSignedIn'));
});
