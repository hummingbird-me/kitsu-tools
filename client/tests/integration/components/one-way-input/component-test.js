import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('one-way-input', 'Integration | Component | one way input', {
  integration: true
});

test('it works', function(assert) {
  assert.expect(4);

  this.set('testValue', 'default');
  this.set('otherValue', null);
  this.render(hbs`{{one-way-input value=testValue update=(action (mut otherValue))}}`);
  assert.ok(this.$('input').length, 'it renders the input element');

  // assert that it is not using two-way binding on value
  assert.equal(this.$('input').val(), 'default');
  this.$('input').val('updated').trigger('change');
  assert.equal(this.get('testValue'), 'default');
  assert.equal(this.get('otherValue'), 'updated');
});
