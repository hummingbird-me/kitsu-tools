import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('foundation-dropdown', 'Integration | Component | foundation dropdown', {
  integration: true
});

test('it renders', function(assert) {
  assert.expect(2);
  this.render(hbs`
    {{#foundation-dropdown dropdownId="test"}}
      Hello, World!
    {{/foundation-dropdown}}
  `);

  assert.equal(this.$('#test').length, 1);
  assert.equal(this.$().text().trim(), 'Hello, World!');
});
