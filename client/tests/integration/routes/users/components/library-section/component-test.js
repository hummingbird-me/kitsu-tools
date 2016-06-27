import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('library-section', 'Integration | Component | library-section', {
  integration: true
});

test('it renders', function(assert) {
  assert.expect(2);
  this.set('section', {
    entries: [{
      media: { episodeCount: 13, episodeLength: 24 }
    }]
  });

  this.render(hbs`{{users/components/library-section
    section=section
  }}`);
  assert.ok(this.$('[data-test-selector="library-section"]').length);

  const text = this.$('[data-test-selector="library-section-stats"]').text().trim();
  assert.equal(text, '1 title — 5 hours, 12 minutes');
});
