import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('box-select-option', 'Integration | Component | box select option', {
  integration: true
});

test('it renders', function(assert) {
  assert.expect(3);

  this.set('option', { name: 'abc', selected: false });
  this.set('testSelect', () => {
    assert.ok(true);
  });

  this.render(hbs`{{#box-select-option
    option=option
    onSelect=(action testSelect)
  }}
    {{option.name}}
  {{/box-select-option}}`);

  this.$('li').click();
  assert.ok(this.$('li').hasClass('active'));
  assert.equal('abc', this.$('li').text().trim());
});
