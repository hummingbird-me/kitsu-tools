import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('library-entry', 'Integration | Component | library-entry', {
  integration: true
});

test('it renders', function(assert) {
  assert.expect(2);
  this.set('entry', {
    media: { canonicalTitle: 'Spice and Wolf' }
  });
  this.render(hbs`{{users/components/library-entry entry=entry}}`);
  assert.ok(this.$('[data-test-selector="library-entry"]').length);
  assert.equal(this.$('[data-test-selector="library-entry-title"]').text().trim(), 'Spice and Wolf');
});
