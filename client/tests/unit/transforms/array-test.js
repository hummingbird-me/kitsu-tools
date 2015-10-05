import { moduleFor, test } from 'ember-qunit';

moduleFor('transform:array', 'Unit | Transform | array', {
  // Specify the other units that are required for this test.
  // needs: ['serializer:foo']
});

test('#serialize', function(assert) {
  assert.expect(3);
  const transform = this.subject();

  assert.deepEqual(transform.serialize(null), []);
  assert.deepEqual(transform.serialize(undefined), []);
  assert.deepEqual(transform.serialize([1, 2, 3]), [1, 2, 3]);
});

test('#deserialize', function(assert) {
  assert.expect(3);
  const transform = this.subject();

  assert.deepEqual(transform.deserialize(null), null);
  assert.deepEqual(transform.deserialize(undefined), undefined);
  assert.deepEqual(transform.deserialize([1, 2, 3]), [1, 2, 3]);
});
