import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('site-header', 'Integration | Component | site-header', {
  integration: true
});

test('it renders', function(assert) {
  assert.expect(1);
  this.render(hbs`{{application/components/site-header}}`);
  assert.ok(this.$('[data-test-selector="site-header"]').length);
});
