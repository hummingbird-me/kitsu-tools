import Ember from 'ember';
import CanonicalUrlRedirectMixin from '../../../mixins/canonical-url-redirect';
import { module, test } from 'qunit';

module('Unit | Mixin | canonical url redirect');

test('it works', function(assert) {
  const CanonicalUrlRedirectObject = Ember.Object.extend(CanonicalUrlRedirectMixin);
  const subject = CanonicalUrlRedirectObject.create();
  assert.ok(subject);
});
