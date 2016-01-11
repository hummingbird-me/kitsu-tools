import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('foundation-button', 'Integration | Component | foundation button', {
  integration: true
});

test('it renders', function(assert) {
  assert.expect(3);
  this.render(hbs`
    {{#foundation-button data-toggle="hello" data-test-selector="world"}}
      Hello, World!
    {{/foundation-button}}
  `);

  assert.equal(this.$('[data-toggle="hello"]').length, 1);
  assert.equal(this.$('[data-test-selector="world"]').length, 1);
  assert.equal(this.$().text().trim(), 'Hello, World!');
});
