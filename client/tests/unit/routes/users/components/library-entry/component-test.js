import { moduleForComponent } from 'ember-qunit';
import EmberObject from 'ember-object';
import { testValidPropertyValues, testInvalidPropertyValues } from 'client/tests/helpers/validate-properties';

moduleForComponent('users/components/library-entry', 'Unit | Component | library entry', {
  unit: true,
  needs: [
    'service:validations',
    'ember-validations@validator:local/numericality',
    'ember-validations@validator:local/presence'
  ],

  beforeEach() {
    this.subject({
      entry: EmberObject.create()
    });
  }
});

testValidPropertyValues('entry.progress', [0, 10, 50]);
testInvalidPropertyValues('entry.progress', ['abc', 1.5, -1]);

testValidPropertyValues('entry.reconsumeCount', [0, 10]);
testInvalidPropertyValues('entry.reconsumeCount', ['abc', 1.5, -1]);
