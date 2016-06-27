import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('library-button', 'Integration | Component | library-button', {
  integration: true,

  beforeEach() {
    this.status = {
      key: 'current',
      string: 'Currently Watching'
    };
  }
});

test('renders the current status', function(assert) {
  assert.expect(2);
  this.set('status', this.status);
  this.render(hbs`{{users/components/library-button status=status}}`);

  const $el = this.$('a');
  assert.equal($el.length, 1);
  assert.equal($el.text().trim(), 'Currently Watching');
});

test('triggers the action with the status key', function(assert) {
  assert.expect(1);
  this.set('status', this.status);
  this.set('action', (number) => assert.equal(number, 1));
  this.set('isActive', false);

  this.render(hbs`{{users/components/library-button
    status=status
    isActive=isActive
    onClick=action
  }}`);

  const $el = this.$('a');
  $el.click();
  this.set('isActive', true);
  $el.click();
});
