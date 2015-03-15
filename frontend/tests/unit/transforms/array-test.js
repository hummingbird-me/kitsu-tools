import {
  moduleFor,
  test
} from 'ember-qunit';

moduleFor('transform:array', 'ArrayTransform', {
  // Specify the other units that are required for this test.
  // needs: ['serializer:foo']
});

test("#serialize", function() {
  var transform = this.subject();

  deepEqual(transform.serialize(null), []);
  deepEqual(transform.serialize(undefined), []);
  deepEqual(transform.serialize([1,2,3]), [1,2,3]);
});

test("#deserialize", function() {
  var transform = this.subject();

  equal(transform.deserialize(null), null);
  equal(transform.deserialize(undefined), undefined);
  deepEqual(transform.deserialize([1,2,3]), [1,2,3]);
});
