import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';
import libraryStatus from 'client/utils/library-status';
import RSVP from 'rsvp';

moduleForComponent('library-dropdown', 'Integration | Component | library-dropdown', {
  integration: true
});

test('it resolves the promise and renders', function(assert) {
  assert.expect(2);
  this.set('entry', undefined);
  this.set('promise', new RSVP.Promise(() => {
    assert.ok(true);
  }));
  this.render(hbs`{{library-dropdown
    entry=entry
    promise=promise
    mediaType="anime"
  }}`);

  const $el = this.$('[data-test-selector="library-dropdown"]');
  assert.equal($el.length, 1);
});

test('it lists the correct statuses', function(assert) {
  this.set('entry', undefined);
  this.set('promise', new RSVP.Promise(() => {}));
  this.render(hbs`{{library-dropdown
    entry=entry
    promise=promise
    mediaType="anime"
  }}`);

  const statuses = libraryStatus.getEnumKeys();
  let $el = this.$('[data-test-selector="library-dropdown-list-item"]');
  assert.equal($el.length, statuses.length);
  assert.equal($el.eq(0).text().trim(), 'Currently Watching');

  // At this point, the current status should be removed and the REMOVE_KEY added
  this.set('entry', { status: 'current' });
  $el = this.$('[data-test-selector="library-dropdown-list-item"]');
  assert.equal($el.length, statuses.length);
  assert.equal($el.eq(0).text().trim(), 'Plan To Watch');
  assert.equal($el.last().text().trim(), 'Remove from Library');
});

test('actions are invoked based on entry status', function(assert) {
  assert.expect(3);

  this.set('entry', { status: 'planned' });
  this.set('create', (status) => assert.equal(status, 'current'));
  this.set('update', (status) => assert.equal(status, 'current'));
  this.set('delete', () => new RSVP.Promise(() => {}));

  this.render(hbs`{{library-dropdown
    entry=entry
    mediaType="anime"
    create=create
    update=update
    delete=delete
  }}`);

  // test update from planned -> current
  const $el = this.$('[data-test-selector="library-dropdown-list-item"]');
  $el.eq(0).find('a').click();

  // test creation
  this.set('entry', undefined);
  $el.eq(0).find('a').click();

  // test deletion
  this.set('entry', { status: 'planned' });
  $el.last().find('a').click();

  // during this time the text is changed to Updating...
  const $btn = this.$('[data-test-selector="library-dropdown"]');
  assert.equal($btn.text().trim(), 'Updating...');
});
