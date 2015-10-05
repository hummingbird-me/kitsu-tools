import { moduleFor, test } from 'ember-qunit';

moduleFor('transform:object', 'Unit | Transform | object', {
  // Specify the other units that are required for this test.
  // needs: ['serializer:foo']
});

test('#serialize', function(assert) {
  assert.expect(3);
  const transform = this.subject();

  assert.deepEqual(transform.serialize(null), {});
  assert.deepEqual(transform.serialize(undefined), {});
  assert.deepEqual(transform.serialize({ foo: 'bar' }), { foo: 'bar' });
});

test('#deserialize', function(assert) {
  assert.expect(3);
  const transform = this.subject();

  assert.deepEqual(transform.deserialize(null), null);
  assert.deepEqual(transform.deserialize(undefined), undefined);
  assert.deepEqual(transform.deserialize({ foo: 'bar' }), { foo: 'bar' });
});
