import EmberObject from 'ember-object';
import { moduleFor } from 'ember-qunit';
import { testValidPropertyValues, testInvalidPropertyValues } from 'client/tests/helpers/validate-properties';

moduleFor('controller:sign-up', 'Unit | Controller | sign up', {
  // Specify the other units that are required for this test
  needs: [
    'service:metrics',
    'service:validations',
    'ember-validations@validator:local/presence',
    'ember-validations@validator:local/length',
    'ember-validations@validator:local/format'
  ],

  beforeEach() {
    this.subject({
      user: EmberObject.create()
    });
  }
});

testValidPropertyValues('user.email', ['a@b.com', 'email+ignore@host.tld']);
testInvalidPropertyValues('user.email', ['abc', 'abc@a', 'abc@abc.', '', null, undefined]);

testValidPropertyValues('user.name', ['vevix', '12345abc']);
testInvalidPropertyValues('user.name', ['ab', '12345', '_vevix', 'abcdefghijklmnopqrstu', '', null, undefined]);

testValidPropertyValues('user.password', ['password']);
testInvalidPropertyValues('user.password', ['not8', '', null, undefined]);
