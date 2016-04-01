import EmberObject from 'ember-object';
import CanonicalUrlRedirectMixin from '../../../mixins/canonical-url-redirect';
import { module, test } from 'qunit';

module('Unit | Mixin | canonical url redirect');

test('it works', function(assert) {
  const CanonicalUrlRedirectObject = EmberObject.extend(CanonicalUrlRedirectMixin);
  const subject = CanonicalUrlRedirectObject.create();
  assert.ok(subject);
});
