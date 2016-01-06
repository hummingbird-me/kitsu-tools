import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('box-select', 'Integration | Component | box select', {
  integration: true
});

test('it renders', function(assert) {
  assert.expect(3);

  this.set('selection', ['abc', 'def']);
  this.set('selected', []);
  this.set('testSelect', () => {
    assert.ok(true);
  });

  this.render(hbs`{{#box-select
    selection=selection
    selected=selected
    onSelect=(action testSelect) as |option|
  }}
    {{option.name}}
  {{/box-select}}`);

  this.$('li').eq(0).click();
  assert.equal(this.$('li').length, 2);
  assert.equal('abc', this.$('li').eq(0).text().trim());
});
