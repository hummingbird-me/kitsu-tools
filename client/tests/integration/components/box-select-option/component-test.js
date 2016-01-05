import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('box-select-option', 'Integration | Component | box select option', {
  integration: true
});

test('it renders', function(assert) {
  assert.expect(2);

  this.set('option', { key: 'abc', label: 'def', selected: false });
  this.set('testSelect', () => {
    assert.ok(true);
  });

  this.render(hbs`{{box-select-option
    option=option
    onSelect=(action testSelect)
  }}`);

  this.$('li').click();
  assert.ok(this.$('li').hasClass('active'));
});
