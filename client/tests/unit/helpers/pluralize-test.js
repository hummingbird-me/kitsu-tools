import { pluralize } from '../../../helpers/pluralize';
import { module, test } from 'qunit';

module('Unit | Helper | pluralize');

// Replace this with your real tests.
test('it works', function(assert) {
  assert.expect(3);

  assert.equal(pluralize(1, { single: 'day', plural: 'days' }), '1 day');
  assert.equal(pluralize(0, { single: 'day', plural: 'days' }), '0 days');
  assert.equal(pluralize(200, { single: 'day', plural: 'days' }), '200 days');
});
