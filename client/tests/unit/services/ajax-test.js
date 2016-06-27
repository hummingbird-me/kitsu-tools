import { moduleFor, test } from 'ember-qunit';
import get from 'ember-metal/get';

moduleFor('service:ajax', 'Unit | Service | ajax');

test('authentication headers are added to ajax requests', function(assert) {
  assert.expect(1);
  const service = this.subject({
    session: {
      isAuthenticated: true,
      authorize(_, fn) {
        fn('Test-Header', 'Test');
      }
    }
  });
  const result = get(service, 'headers');
  assert.deepEqual(result, { 'Test-Header': 'Test' });
});

test('#options uses full URL if `includesHost` is true', function(assert) {
  assert.expect(2);
  const service = this.subject({ session: { isAuthenticated: false } });
  let result = service.options('/relative', {});
  assert.equal(result.url, '/api/edge/relative');
  result = service.options('https://example.com/absolute', { includesHost: true });
  assert.equal(result.url, 'https://example.com/absolute');
});
