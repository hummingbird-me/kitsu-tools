import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('box-select-option', 'Integration | Component | box select option', {
  integration: true
});

test('it renders', function(assert) {
  this.set('option', 'abc');
  this.render(hbs`{{#box-select-option
    option=option
    isActive=true
  }}
    {{option}}
  {{/box-select-option}}`);

  assert.ok(this.$('li').hasClass('active'));
  assert.equal(this.$('li').text().trim(), 'abc');
});

test('action is executed', function(assert) {
  assert.expect(1);
  this.set('option', 'abc');
  this.set('testSelect', () => {
    assert.ok(true);
  });

  this.render(hbs`
    {{#box-select-option
      option=option
      onSelect=(action testSelect)}}
      {{option}}
    {{/box-select-option}}
  `);

  this.$('li').click();
});
