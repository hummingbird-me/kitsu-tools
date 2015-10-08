import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('foundation-callout', 'Integration | Component | foundation callout', {
  integration: true
});

test('it renders', function(assert) {
  assert.expect(3);
  this.render(hbs`{{foundation-callout type="success" closable=true}}`);

  // type is set
  const $alert = this.$('.callout.success');
  assert.equal($alert.length, 1);

  // button is created
  const $button = this.$('.callout button');
  assert.equal($button.length, 1);
  assert.equal($button.text().trim(), '×');
});

test('block renders', function(assert) {
  assert.expect(1);
  this.render(hbs`
    {{#foundation-callout type="success" closable=false}}
      Hello, World!
    {{/foundation-callout}}
  `);

  // text is displayed
  const $alert = this.$('.callout.success');
  assert.equal($alert.text().trim(), 'Hello, World!');
});
