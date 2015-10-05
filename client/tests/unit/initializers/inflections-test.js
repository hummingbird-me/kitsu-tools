import Ember from 'ember';
import { initialize } from '../../../initializers/inflections';
import { module, test } from 'qunit';

const { run, String: { pluralize } } = Ember;

module('Unit | Initializer | inflections', {
  beforeEach() {
    run(() => {
      this.application = Ember.Application.create();
      this.registry = this.application.registry;
      this.application.deferReadiness();
    });
  }
});

test('it works', function(assert) {
  assert.expect(3);
  initialize(this.registry, this.application);
  assert.equal(pluralize('anime'), 'anime');
  assert.equal(pluralize('manga'), 'manga');
  assert.equal(pluralize('drama'), 'drama');
});
