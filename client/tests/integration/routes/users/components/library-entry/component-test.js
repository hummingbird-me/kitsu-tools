import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('library-entry', 'Integration | Component | library-entry', {
  integration: true
});

test('it renders', function(assert) {
  assert.expect(1);
  this.render(hbs`{{users/components/library-entry}}`);
  assert.ok(this.$('[data-test-selector="library-entry"]').length);
});
