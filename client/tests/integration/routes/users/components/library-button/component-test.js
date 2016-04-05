import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('library-button', 'Integration | Component | library-button', {
  integration: true
});

test('it renders', function(assert) {
  assert.expect(1);
  this.render(hbs`{{users/components/library-button}}`);
  assert.equal(this.$('a').length, 1);
});
