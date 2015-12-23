import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('library-list-section', 'Integration | Component | library-list-section', {
  integration: true
});

test('it renders', function(assert) {
  assert.expect(1);
  this.render(hbs`{{users/components/library-list-section}}`);
  assert.ok(this.$('[data-test-selector="library-list-section"]').length);
});
