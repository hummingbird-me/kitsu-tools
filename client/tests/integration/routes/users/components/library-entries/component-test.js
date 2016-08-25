import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('library-entries', 'Integration | Component | library-entries', {
  integration: true
});

test('it renders', function(assert) {
  assert.expect(2);
  this.set('entries', [{
    media: { episodeCount: 13, episodeLength: 24 }
  }]);

  this.render(hbs`{{users/components/library-entries
    entries=entries
  }}`);
  assert.ok(this.$('[data-test-selector="library-entries"]').length);

  const text = this.$('[data-test-selector="library-entries-stats"]').text().trim();
  assert.equal(text, '1 title — 5 hours, 12 minutes');
});
