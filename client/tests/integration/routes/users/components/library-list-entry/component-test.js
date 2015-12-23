import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('library-list-entry', 'Integration | Component | library-list-entry', {
  integration: true
});

test('it renders', function(assert) {
  assert.expect(1);
  this.render(hbs`{{users/components/library-list-entry}}`);
  assert.ok(this.$('[data-test-selector="library-list-entry"]').length);
});
