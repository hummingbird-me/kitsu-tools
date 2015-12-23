import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('library-section-button', 'Integration | Component | library-section-button', {
  integration: true
});

test('it renders', function(assert) {
  assert.expect(1);
  this.render(hbs`{{users/components/library-section-button}}`);
  assert.equal(this.$('a').length, 1);
});
