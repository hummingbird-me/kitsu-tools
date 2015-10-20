import getApiHost from '../../../utils/get-api-host';
import { module, test } from 'qunit';
import config from 'client/config/environment';

module('Unit | Utility | get api host');

test('it works', function(assert) {
  assert.expect(3);
  assert.equal(getApiHost(), '');

  config.apiHost = 'http://local.host';
  assert.equal(getApiHost(), 'http://local.host');

  config.apiHost = undefined;
  assert.equal(getApiHost(), 'http://localhost:3000');
});
