import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('library-status-button', 'Integration | Component | library-status-button', {
  integration: true
});

test('it renders', function(assert) {
  assert.expect(1);
  this.render(hbs`{{library-status-button}}`);
  const $el = this.$('[data-test-selector="library-status-button-entry"]');
  assert.equal($el.length, 1);
});
