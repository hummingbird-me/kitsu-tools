import Ember from 'ember';
import MediaModelMixin from '../../../mixins/media-model';
import { module, test } from 'qunit';

module('Unit | Mixin | media model');

// Replace this with your real tests.
test('it works', function(assert) {
  const MediaModelObject = Ember.Object.extend(MediaModelMixin);
  const subject = MediaModelObject.create();
  assert.ok(subject);
});
