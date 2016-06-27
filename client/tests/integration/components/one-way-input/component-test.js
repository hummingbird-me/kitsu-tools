import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('one-way-input', 'Integration | Component | one-way-input', {
  integration: true
});

test('input sanitization', function(assert) {
  assert.expect(3);
  this.set('update', (value) => assert.equal(typeof value, 'string'));
  this.render(hbs`{{one-way-input update=update}}`);

  // update() should receive 'Hello, World' string
  this.$('input').val('Hello, World').change();
  // update() should receive '10a' string
  this.$('input').val('10a').change();
  // update() should receieve 9001 number
  this.set('update', (value) => assert.equal(typeof value, 'number'));
  this.$('input').val('9001').change();
});
