import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import jQuery from 'jquery';

moduleForComponent('media-poster', 'Integration | Component | media-poster', {
  integration: true
});

test('it renders', function(assert) {
  this.set('media', { constructor: { modelName: 'anime' } });
  this.render(hbs`{{media/components/media-poster media=media}}`);
  const $el = this.$('[data-test-selector="media-poster"]');
  assert.equal($el.length, 1);

  // trailer modal can be opened
  assert.equal(jQuery('[data-reveal]').length, 0);
  const $trailer = this.$('[data-test-selector="media-poster-trailer"]');
  $trailer.find('a').click();
  assert.equal(jQuery('[data-reveal]').length, 1);
});
