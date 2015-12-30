import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('library-status-button', 'Integration | Component | library-status-button', {
  integration: true
});

test('it renders', function(assert) {
  assert.expect(2);
  this.render(hbs`{{library-status-button}}`);
  let $el = this.$('[data-test-selector="library-status-button"]');
  assert.equal($el.length, 0);

  this.render(hbs`{{library-status-button entry=1}}`);
  $el = this.$('[data-test-selector="library-status-button"]');
  assert.equal($el.length, 1);
});
