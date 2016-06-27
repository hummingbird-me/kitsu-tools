import { moduleForModel, test } from 'ember-qunit';
import localeConfig from 'ember-i18n/config/en';
import testValidations from 'client/tests/helpers/test-validations';

moduleForModel('library-entry', 'Unit | Model | library-entry', {
  // Specify the other units that are required for this test.
  needs: [
    'service:i18n',
    'locale:en/translations',
    'util:i18n/missing-message',
    'util:i18n/compile-template',
    'config:environment',
    'validator:presence',
    'validator:number',
    'validator:messages',
    'model:media',
    'model:user'
  ],

  beforeEach() {
    this.registry.register('locale:en/config', localeConfig);
  }
});

test('model validations', function(assert) {
  const entry = this.subject();
  const valid = {
    progress: [0, 10, 50],
    reconsumeCount: [0, 10]
  };
  const invalid = {
    progress: ['abc', 1.5, -1],
    reconsumeCount: ['abc', 1.5, -1]
  };

  testValidations(entry, valid, invalid, assert);
});
