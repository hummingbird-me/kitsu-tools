import { moduleFor } from 'ember-qunit';
import { testValidPropertyValues, testInvalidPropertyValues } from 'client/tests/helpers/validate-properties';

moduleFor('controller:sign-up', 'Unit | Controller | sign up', {
  // Specify the other units that are required for this test
  needs: ['service:metrics', 'service:validations',
    'ember-validations@validator:local/presence',
    'ember-validations@validator:local/length',
    'ember-validations@validator:local/format']
});

testValidPropertyValues('model.email', ['a@b.com'], (subject) => {
  subject.set('model', { email: '' });
});
testInvalidPropertyValues('model.email', ['abc', 'abc@a', 'abc@abc.', '', null, undefined], (subject) => {
  subject.set('model', { email: '' });
});

testValidPropertyValues('model.name', ['vevix', '12345abc'], (subject) => {
  subject.set('model', { username: '' });
});
testInvalidPropertyValues('model.name',
  ['ab', '12345', '_vevix', 'abcdefghijklmnopqrstu', '', null, undefined],
  (subject) => {
    subject.set('model', { username: '' });
  });

testValidPropertyValues('model.password', ['password'], (subject) => {
  subject.set('model', { password: '' });
});
testInvalidPropertyValues('model.password', ['not8', '', null, undefined],
  (subject) => {
    subject.set('model', { password: '' });
  });
