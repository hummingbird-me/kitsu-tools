import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import jQuery from 'jquery';

moduleForComponent('media-poster-summary', 'Integration | Component | media-poster-summary', {
  integration: true
});

test('it renders', function(assert) {
  this.render(hbs`{{media-poster-summary}}`);
  const $el = this.$('[data-test-selector="media-poster-summary"]');
  assert.equal($el.length, 1);

  // trailer modal can be opened
  assert.equal(jQuery('[data-reveal]').length, 0);
  const $trailer = this.$('[data-test-selector="media-poster-summary-trailer"]');
  $trailer.find('a').click();
  assert.equal(jQuery('[data-reveal]').length, 1);
});
