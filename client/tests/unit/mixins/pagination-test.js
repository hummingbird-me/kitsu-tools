import Ember from 'ember';
import PaginationMixin from 'client/mixins/pagination';
import { module, test } from 'qunit';

module('Unit | Mixin | pagination');

test('#_parseLink', function(assert) {
  const PaginationObject = Ember.Object.extend(PaginationMixin);
  const subject = PaginationObject.create();
  let result = subject._parseLink('https://example.com?param=true');
  assert.deepEqual(result, { param: 'true' });
  result = subject._parseLink('https://example.com?filter[slug]=hello-world&filter[param]=true');
  assert.deepEqual(result, {
    filter: {
      slug: 'hello-world',
      param: 'true'
    }
  });
  result = subject._parseLink('https://example.com');
  assert.deepEqual(result, {});
});
