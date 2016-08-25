import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('library-select', 'Integration | Component | library-select', {
  integration: true
});

test('renders the current status', function(assert) {
  assert.expect(2);
  this.set('status', 'current');
  this.render(hbs`{{users/components/library-select
    mediaType="anime"
    status=status
  }}`);

  const $el = this.$('a');
  assert.equal($el.length, 1);
  assert.equal($el.text().trim(), 'Currently Watching');
});

test('triggers the action with the status key', function(assert) {
  assert.expect(1);
  this.set('status', 'current');
  this.set('action', (status) => assert.equal(status, 'current'));
  this.set('isActive', false);

  this.render(hbs`{{users/components/library-select
    status=status
    isActive=isActive
    onClick=action
  }}`);

  const $el = this.$('a');
  $el.click();
  this.set('isActive', true);
  $el.click();
});
