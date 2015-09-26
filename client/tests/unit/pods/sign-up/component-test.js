import { moduleForComponent } from 'ember-qunit';
import { testValidPropertyValues, testInvalidPropertyValues } from 'client/tests/helpers/validate-properties';

moduleForComponent('sign-up', 'Unit | Component | sign up', {
  // Specify the other units that are required for this test
  needs: ['service:validations',
    'ember-validations@validator:local/presence',
    'ember-validations@validator:local/length',
    'ember-validations@validator:local/format'],
  unit: true
});

testValidPropertyValues('model.email', ['a@b.com'], (subject) => {
  subject.set('model', { email: '' });
});
testInvalidPropertyValues('model.email', ['', null, undefined], (subject) => {
  subject.set('model', { email: '' });
});

testValidPropertyValues('model.username', ['vevix', '12345abc'], (subject) => {
  subject.set('model', { username: '' });
});
testInvalidPropertyValues('model.username',
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
