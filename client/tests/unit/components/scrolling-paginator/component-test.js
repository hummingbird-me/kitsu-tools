import { moduleForComponent, test } from 'ember-qunit';

moduleForComponent('scrolling-paginator', 'Unit | Component | scrolling-paginator', {
  unit: true
});

test('#_parseLink', function(assert) {
  const component = this.subject();
  let result = component._parseLink('https://example.com?param=true');
  assert.deepEqual(result, { param: 'true' });
  result = component._parseLink('https://example.com?filter[slug]=hello-world&filter[param]=true');
  assert.deepEqual(result, {
    filter: {
      slug: 'hello-world',
      param: 'true'
    }
  });
  result = component._parseLink('https://example.com');
  assert.deepEqual(result, {});
});
