import {
  moduleFor,
  test
} from 'ember-qunit';

moduleFor('controller:header', 'HeaderController', {
  // Specify the other units that are required for this test.
  needs: ['controller:application', 'controller:notifications']
});

// Replace this with your real tests.
test('it exists', function() {
  var controller = this.subject();
  ok(controller);
});
