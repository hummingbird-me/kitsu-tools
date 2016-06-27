import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('box-select', 'Integration | Component | box select', {
  integration: true
});

test('it renders', function(assert) {
  assert.expect(2);
  this.set('selection', ['one', 'two', 'three']);
  this.render(hbs`
    {{#box-select selection=selection as |option|}}
      {{option}}
    {{/box-select}}
  `);

  assert.equal(this.$('li').length, 3);
  assert.equal(this.$('li').eq(0).text().trim(), 'one');
});

test('element is selected upon action', function(assert) {
  assert.expect(1);
  this.set('selection', ['one', 'two', 'three']);
  this.set('selected', ['two', 'three']);
  this.set('testSelect', (value) => {
    assert.deepEqual(value, ['two', 'three', 'one']);
  });

  this.render(hbs`{{#box-select
    selection=selection
    selected=selected
    onSelect=(action testSelect) as |option|
  }}
    {{option}}
  {{/box-select}}`);

  this.$('li').eq(0).click();
});

test('element is deselected upon action', function(assert) {
  assert.expect(1);
  this.set('selection', ['one', 'two', 'three']);
  this.set('selected', ['one', 'two', 'three']);
  this.set('testSelect', (value) => {
    assert.deepEqual(value, ['one', 'three']);
  });

  this.render(hbs`{{#box-select
    selection=selection
    selected=selected
    onSelect=(action testSelect) as |option|
  }}
    {{option}}
  {{/box-select}}`);

  this.$('li').eq(1).click();
});
