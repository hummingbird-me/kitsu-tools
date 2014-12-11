import {
  moduleFor,
  test
} from 'ember-qunit';

moduleFor('controller:onboarding/finish', 'OnboardingFinishController', {
  // Specify the other units that are required for this test.
  needs: ['controller:current-user']
});

// Replace this with your real tests.
test('it exists', function() {
  var controller = this.subject();
  ok(controller);
});
