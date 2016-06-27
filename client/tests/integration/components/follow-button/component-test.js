import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('follow-button', 'Integration | Component | follow-button', {
  integration: true
});

test('it renders', function(assert) {
  this.render(hbs`{{follow-button}}`);
  const $el = this.$('[data-test-selector="follow-button"]');
  assert.equal($el.text().trim(), 'Follow');
});
