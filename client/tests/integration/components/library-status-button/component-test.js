import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import libraryStatus from 'client/utils/library-status';
import RSVP from 'rsvp';

moduleForComponent('library-status-button', 'Integration | Component | library-status-button', {
  integration: true
});

test('it renders', function(assert) {
  this.set('entry', undefined);
  this.set('entryIsLoaded', false);
  this.render(hbs`{{library-status-button
    entry=entry
    entryIsLoaded=entryIsLoaded}}`);

  const $el = this.$('[data-test-selector="library-status-button"]');
  assert.equal($el.length, 1);

  // renders the correct text
  this.set('entryIsLoaded', false);
  assert.equal($el.text().trim(), 'Loading...');
  this.set('entryIsLoaded', true);
  assert.equal($el.text().trim(), 'Add to Library');
});

test('the statuses are listed correctly', function(assert) {
  this.set('mediaType', 'anime');
  this.set('entry', undefined);
  this.render(hbs`{{library-status-button mediaType=mediaType entry=entry}}`);

  const statuses = libraryStatus.getEnumKeys();
  let $el = this.$('[data-test-selector="library-list-button-status"]');
  assert.equal($el.length, statuses.length);
  assert.equal($el.eq(0).text().trim(), 'Currently Watching');

  // At this point, the current status should be removed and the REMOVE_KEY added
  this.set('entry', { status: 'current' });
  $el = this.$('[data-test-selector="library-list-button-status"]');
  assert.equal($el.length, statuses.length);
  assert.equal($el.eq(0).text().trim(), 'Plan To Watch');
  assert.equal($el.last().text().trim(), 'Remove from Library');
});

test('actions are invoked based on entry status', function(assert) {
  assert.expect(3);

  this.set('mediaType', 'anime');
  this.set('entry', { status: 'planned' });
  this.set('create', (status) => assert.equal(status, 'current'));
  this.set('update', (status) => assert.equal(status, 'current'));
  this.set('delete', () => new RSVP.Promise(() => {}));

  this.render(hbs`{{library-status-button
    mediaType=mediaType entry=entry
    update=update create=create delete=delete}}`);

  // test update from planned -> current
  const $el = this.$('[data-test-selector="library-list-button-status"]');
  $el.eq(0).find('a').click();

  // test creation
  this.set('entry', undefined);
  $el.eq(0).find('a').click();

  // test deletion
  this.set('entry', { status: 'planned' });
  $el.last().find('a').click();

  // during this time the text is changed to Updating...
  const $btn = this.$('[data-test-selector="library-status-button"]');
  assert.equal($btn.text().trim(), 'Updating...');
});
