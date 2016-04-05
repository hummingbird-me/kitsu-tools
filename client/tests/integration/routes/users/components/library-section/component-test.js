import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('library-section', 'Integration | Component | library-section', {
  integration: true
});

test('it renders', function(assert) {
  assert.expect(1);
  this.render(hbs`{{users/components/library-section}}`);
  assert.ok(this.$('[data-test-selector="library-section"]').length);
});
