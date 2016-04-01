import Ember from 'ember';
import run from 'ember-runloop';
import Application from 'ember-application';
import { initialize } from '../../../initializers/inflections';
import { module, test } from 'qunit';

const {
  String: { pluralize }
} = Ember;

module('Unit | Initializer | inflections', {
  beforeEach() {
    run(() => {
      this.application = Application.create();
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
