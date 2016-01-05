import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('box-select', 'Integration | Component | box select', {
  integration: true
});

test('it renders', function(assert) {
  assert.expect(2);

  this.set('selection', [{ key: 'abc', label: 'def' }, { key: 'abc', label: 'def' }]);
  this.set('selected', []);
  this.set('testSelect', () => {
    assert.ok(true);
  });

  this.render(hbs`{{box-select
    selection=selection
    selected=selected
    onSelect=(action testSelect)
  }}`);

  this.$('li').eq(0).click();
  assert.equal(this.$('li').length, 2);
});
