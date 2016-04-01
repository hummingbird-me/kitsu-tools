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
      model: EmberObject.create()
    });
  }
});

testValidPropertyValues('model.email', ['a@b.com', 'email+ignore@host.tld']);
testInvalidPropertyValues('model.email', ['abc', 'abc@a', 'abc@abc.', '', null, undefined]);

testValidPropertyValues('model.name', ['vevix', '12345abc']);
testInvalidPropertyValues('model.name', ['ab', '12345', '_vevix', 'abcdefghijklmnopqrstu', '', null, undefined]);

testValidPropertyValues('model.password', ['password']);
testInvalidPropertyValues('model.password', ['not8', '', null, undefined]);
