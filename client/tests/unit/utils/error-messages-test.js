import errorMessages from '../../../utils/error-messages';
import { module, test } from 'qunit';

module('Unit | Utility | error messages');

test('works with backend ajax response', function(assert) {
  assert.expect(1);
  const result = errorMessages({
    jqXHR: {
      responseJSON: {
        errors: [{ detail: 'abc' }, { detail: 'def' }]
      }
    }
  });
  assert.equal(result, 'Abc');
});

test('works with AdapterError response', function(assert) {
  assert.expect(1);
  const result = errorMessages({
    errors: [{ detail: 'abc' }, { detail: 'def' }]
  });
  assert.equal(result, 'Abc');
});

test('works with Doorkeeper response', function(assert) {
  assert.expect(1);
  const result = errorMessages({
    error: 'invalid_grant'
  });
  assert.equal(result, 'The provided credentials are invalid.');
});
