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

testValidPropertyValues('entry.episodesWatched', [0, 10, 50]);
testInvalidPropertyValues('entry.episodesWatched', ['abc', 1.5, -1]);

testValidPropertyValues('entry.rewatchCount', [0, 10]);
testInvalidPropertyValues('entry.rewatchCount', ['abc', 1.5, -1]);
