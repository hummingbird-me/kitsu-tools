import { moduleForModel, test } from 'ember-qunit';
import localeConfig from 'ember-i18n/config/en';
import testValidations from 'client/tests/helpers/test-validations';

moduleForModel('user', 'Unit | Model | user', {
  // Specify the other units that are required for this test.
  needs: [
    'service:i18n',
    'locale:en/translations',
    'util:i18n/missing-message',
    'util:i18n/compile-template',
    'config:environment',
    'validator:presence',
    'validator:length',
    'validator:format',
    'validator:messages'
  ],

  beforeEach() {
    this.registry.register('locale:en/config', localeConfig);
  }
});

test('model validations', function(assert) {
  const user = this.subject();
  const valid = {
    name: ['Okabe', '123Okabe'],
    email: ['a@b.com', 'email+ignore@host.tld'],
    password: ['password']
  };
  const invalid = {
    name: ['ab', '12345', '_okabe', 'asdadasdasdasdasdadadasd', '', null, undefined],
    email: ['abc', 'abc@a', 'abc@abc.', '', null, undefined],
    password: ['not8', '', null, undefined]
  };

  testValidations(user, valid, invalid, assert);
});
