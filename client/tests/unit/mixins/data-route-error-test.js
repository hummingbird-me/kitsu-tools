import EmberObject from 'ember-object';
import DataRouteErrorMixin from '../../../mixins/data-route-error';
import { module, test } from 'qunit';

module('Unit | Mixin | data route error');

// Replace this with your real tests.
test('it works', function(assert) {
  const DataRouteErrorObject = EmberObject.extend(DataRouteErrorMixin);
  const subject = DataRouteErrorObject.create();
  assert.ok(subject);
});
