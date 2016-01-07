import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('media-poster-summary', 'Integration | Component | media-poster-summary', {
  integration: true
});

test('it renders', function(assert) {
  assert.expect(1);
  this.render(hbs`
    {{media-poster-summary}}
  `);

  assert.equal(this.$('[data-test-selector="media-poster-summary"]').length, 1);
});
