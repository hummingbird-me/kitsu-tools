import errorMessages from '../../../utils/error-messages';
import { module, test } from 'qunit';

module('Unit | Utility | error messages');

// Replace this with your real tests.
test('works with backend ajax response', function(assert) {
  assert.expect(1);
  const result = errorMessages({
    jqXHR: {
      responseJSON: {
        errors: [{ title: 'abc', source: { parameter: 'user' } }, { title: 'def' }]
      }
    }
  });
  assert.equal(result, 'User abc\ndef');
});

test('works with AdapterError response', function(assert) {
  assert.expect(1);
  const result = errorMessages({
    errors: [{ title: 'abc' }, { title: 'def' }]
  });
  assert.equal(result, 'abc\ndef');
});

test('works with Doorkeeper response', function(assert) {
  assert.expect(1);
  const result = errorMessages({
    error: 'invalid_grant'
  });
  assert.equal(result, 'The provided credentials are not valid.');
});
