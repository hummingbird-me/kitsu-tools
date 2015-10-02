import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('one-way-input', 'Integration | Component | one way input', {
  integration: true
});

test('it works', function(assert) {
  assert.expect(3);

  this.set('testValue', null);
  this.set('otherValue', null);
  this.render(hbs`{{one-way-input value=testValue update=(action (mut otherValue))}}`);
  assert.ok(this.$('input').length, 'it renders the input element');

  // assert that it is not using two-way binding on value
  this.$('input').val('updated').trigger('change');
  assert.equal(this.get('testValue'), null);
  // however, the action is sent up.
  assert.equal(this.get('otherValue'), 'updated');
});
