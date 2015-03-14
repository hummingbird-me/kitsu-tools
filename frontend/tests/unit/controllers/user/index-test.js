import {
  moduleFor,
  test
} from 'ember-qunit';

moduleFor('controller:user/index', 'UserIndexController', {
  // Specify the other units that are required for this test.
  needs: ['controller:current-user', 'controller:user']
});

// Replace this with your real tests.
test('it exists', function() {
  var controller = this.subject();
  ok(controller);
});
